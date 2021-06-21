package com.codesqaude.cocomarco.service;

import com.codesqaude.cocomarco.util.PropertyUtil;
import lombok.Getter;

@Getter
public enum GitOAuthType {

    IOS("github.ios.client.id", "github.ios.secret"),
    WEB("github.desktop.client.id", "github.desktop.secret");

    private String clientId;
    private String clientSecret;

    GitOAuthType(String clientId, String clientSecret) {
        this.clientId = PropertyUtil.getProperty(clientId);
        this.clientSecret = PropertyUtil.getProperty(clientSecret);
    }
}
