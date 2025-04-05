package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.Collections;

@WebServlet("/login_google")
public class LoginGoogleController extends HttpServlet {
    private static final String CLIENT_ID = "891978819303-g9qeo4mmukj96bfr51iaaeheeqk1t1eo.apps.googleusercontent.com";
    private AuthService service = new AuthService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        String idTokenString = request.getParameter("credential");
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã đăng nhập rồi.\"}");
            return;
        }
        if (session == null) {
            session = request.getSession(true);
        }
//        String sessionToken = (String) session.getAttribute("CSRF_TOKEN");
//        String requestToken = request.getParameter("csrfToken");
//
//        if (sessionToken == null || !sessionToken.equals(requestToken)) {
//            response.setContentType("application/json");
//            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi bảo mật: CSRF Token không hợp lệ.\"}");
//            return;
//        }else

        if (idTokenString == null || idTokenString.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Token không hợp lệ.\"}");
            return;
        }

        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(), new GsonFactory())
                    .setAudience(Collections.singletonList(CLIENT_ID))
                    .build();

            GoogleIdToken idToken = verifier.verify(idTokenString);

            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                String ggId = payload.getSubject();
                String name = (String) payload.get("name");
                String email = payload.getEmail();

                User user = service.findUserByEmail(email);

                if (user != null) {
                    if (user.getGg_id() == null) {
                        user.setGg_id(ggId);
                        user.setEmail(email);
                        boolean isUpdated = service.updateUserInfo(user);
                        if (!isUpdated) {
                            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                            response.getWriter().write("{\"success\": false, \"message\": \"Không thể lưu thông tin người dùng.\"}");
                            return;
                        }
                    }
                } else {
                    boolean createUser = service.createUserByGoogle(ggId, name, email);
                    if (createUser) {
                        user = service.findGoogleUserById(ggId);
                    } else {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().write("{\"success\": false, \"message\": \"Không thể lưu thông tin người dùng.\"}");
                        return;
                    }
                }
                if (session == null) {
                    session = request.getSession(true);
                }

                session.setAttribute("user", user);

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Xác thực ID Token thất bại.\"}");
            }
        } catch (GeneralSecurityException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi bảo mật.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi truy vấn CSDL.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi không xác định.\"}");
        }
    }

}
