package com.example.web.controller;

import com.example.web.dao.model.User;
import com.example.web.service.AuthService;
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
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;

@WebServlet("/login_fb")
public class LoginFaceController extends HttpServlet {
    private static final String FACEBOOK_GRAPH_URL = "https://graph.facebook.com/me?fields=id,name,email&access_token=";

    private final AuthService service = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String accessToken = request.getParameter("accessToken");

        if (accessToken == null || accessToken.isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Access Token không hợp lệ.\"}");
            return;
        }

        try {
            URL url = new URL(FACEBOOK_GRAPH_URL + accessToken);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();
            if (responseCode != 200) {
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
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");

        } catch (IOException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra trong quá trình đăng nhập.\"}");
        }
    }
}