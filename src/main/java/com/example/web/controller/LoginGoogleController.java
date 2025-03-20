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
    AuthService service = new AuthService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idTokenString = request.getParameter("credential");

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), new GsonFactory())
                .setAudience(Collections.singletonList(CLIENT_ID))
                .build();

        try {
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                String ggId = payload.getSubject();
                String name = (String) payload.get("name");
                String email = payload.getEmail();

                User user = service.findGoogleUserById(ggId);
                if(user == null){
                    boolean createUser = service.createUserByGoogle(ggId, name, email);
                    if (createUser) {
                        user = service.findGoogleUserById(ggId);
                    }
                }
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false}");
            }
        } catch (GeneralSecurityException | SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false}");
        }
    }

}
