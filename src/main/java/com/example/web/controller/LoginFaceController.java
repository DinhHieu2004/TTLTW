package com.example.web.controller;

import com.example.web.dao.model.Level;
import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
import com.example.web.service.LogService;
import com.example.web.utils.SessionManager;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.*;
import java.sql.SQLException;

@WebServlet("/login_fb")
public class LoginFaceController extends HttpServlet {
    private static final String FACEBOOK_GRAPH_URL = "https://graph.facebook.com/me?fields=id,name,email&access_token=";
    private final AuthService service = new AuthService();
    private final LogService logService = new LogService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã đăng nhập rồi.\"}");
            return;
        }
        String accessToken = request.getParameter("accessToken");

        if (accessToken == null || accessToken.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Access Token không hợp lệ.\"}");
            return;
        }

        try {
            URI uri = new URI(FACEBOOK_GRAPH_URL + accessToken);
            URL url = uri.toURL();
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();
            if (responseCode != 200) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Xác thực Access Token thất bại.\"}");
                return;
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder responseContent = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                responseContent.append(inputLine);
            }
            in.close();

            JsonObject userNode = JsonParser.parseString(responseContent.toString()).getAsJsonObject();
            String fbId = userNode.get("id").getAsString();
            String name = userNode.get("name").getAsString();
            String email = userNode.has("email") ? userNode.get("email").getAsString() : null;

            User user = service.findFacebookUserById(fbId);
            if (user == null) {
                boolean createUser = service.createUserByFacebook(fbId, name, email);
                if (createUser) {
                    user = service.findFacebookUserById(fbId);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"message\": \"Không thể tạo tài khoản người dùng.\"}");
                    return;
                }
            }
            if (session == null) {
                session = request.getSession(true);
            }
            if(!user.getStatus().equals("Hoạt động")){
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("Tài khoản của bạn đang bị khóa hoặc chờ xóa.");
                return;
            }
            session.setAttribute("user", user);
            logService.addLog(String.valueOf(Level.INFO), request, "Đăng nhập facebook", "Success");

            HttpSession oldSession = SessionManager.userSessions.get(user.getId() + "");
            if (oldSession != null && oldSession != session) {
                try {
                    oldSession.invalidate();
                } catch (IllegalStateException e) {
                }
            }

            session.setAttribute("uid", user.getId());
            SessionManager.userSessions.put(user.getId() + "", session);



            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.write("{\"success\": true}");
            out.flush();

        } catch (MalformedURLException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"URL không hợp lệ.\"}");
            e.printStackTrace();
        } catch (IOException | SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra khi kết nối tới Facebook API.\"}");
            e.printStackTrace();
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }
}
