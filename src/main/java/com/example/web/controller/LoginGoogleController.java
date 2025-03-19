package com.example.web.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;

@WebServlet("/login_google")
public class LoginGoogleController extends HttpServlet {
    private static final String CLIENT_ID = "891978819303-g9qeo4mmukj96bfr51iaaeheeqk1t1eo.apps.googleusercontent.com";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idTokenString = request.getParameter("credential");

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                new NetHttpTransport(), new GsonFactory())
                .setAudience(Collections.singletonList(CLIENT_ID))
                .build();

        try {
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                String userId = payload.getSubject();
                String email = payload.getEmail();
                String name = (String) payload.get("name");

                HttpSession session = request.getSession();
                session.setAttribute("user", name);
                session.setAttribute("email", email);

                response.sendRedirect(request.getContextPath() + "/");
            } else {
                response.getWriter().println("Xác thực Google thất bại.");
            }
        } catch (GeneralSecurityException e) {
            e.printStackTrace();
        }
    }
}
