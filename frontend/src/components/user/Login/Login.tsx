import styled from "styled-components";
import { Container, TextField, Typography, Box } from "@material-ui/core";
import Logo from "components/common/Logo";
import CustomButton from "components/common/Button";

export default function LoginPage() {
  return (
    <LoginPageWrapper>
      <Logo />
      <CustomButton
        customColor="black"
        customSize="M"
        variant="contained"
        fullWidth
      >
        Github 계정으로 로그인
      </CustomButton>
      <Box my={4}>
        <Typography align="center">or</Typography>
      </Box>
      <Box my={2}>
        <TextField
          id="id"
          label="아이디"
          type="text"
          fullWidth
          variant="filled"
        />
      </Box>
      <Box mb={4}>
        <TextField
          id="passwork"
          type="password"
          label="비밀번호"
          fullWidth
          variant="filled"
        />
      </Box>
      <CustomButton
        customColor="blue"
        customSize="M"
        variant="contained"
        fullWidth
      >
        아이디로 로그인
      </CustomButton>
      <CustomButton customSize="S" fullWidth>
        회원가입
      </CustomButton>
    </LoginPageWrapper>
  );
}

const LoginPageWrapper = styled(Container)`
  width: 500px;
  margin-top: 10rem;
`;

const FormBox = styled(Box)``;
