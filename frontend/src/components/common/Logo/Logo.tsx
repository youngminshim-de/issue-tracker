import styled from "styled-components";
import { Box } from "@material-ui/core";

export default function Logo() {
  return (
    <Box>
      <LogoWrapper />
    </Box>
  );
}

const LogoWrapper = styled.div`
  height: 60px;
  background: url("/assets/logo.png") no-repeat;
  background-size: contain;
  margin-bottom: 61px;
`;
