import React from "react";
import styled from "styled-components";
import Logo from "../Logo";
import { Button } from "@material-ui/core";

export default function Header() {
  return (
    <HeaderWrapper>
      <LogoBox>
        <Logo />
      </LogoBox>{" "}
      <LoginButton>
        <Button variant="outlined">로그인하기</Button>
      </LoginButton>
    </HeaderWrapper>
  );
}

const HeaderWrapper = styled.div`
  display: flex;
  justify-content: space-between;
`;
const LogoBox = styled.div`
  width: 200px;
`;
const LoginButton = styled.div``;
