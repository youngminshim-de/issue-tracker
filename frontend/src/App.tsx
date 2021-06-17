import { Suspense } from "react";
import { ThemeProvider } from "styled-components";
import { theme } from "styles";
import {
  unstable_createMuiStrictModeTheme,
  ThemeProvider as MuiThemeProvider,
} from "@material-ui/core";
import GlobalStyled from "styles/GlobalStyled";
import Routers from "components/core/Routers";
import Header from "components/common/Header";
import styled from "styled-components";

const MuiTheme = unstable_createMuiStrictModeTheme();

function App() {
  return (
    <MuiThemeProvider theme={MuiTheme}>
      <ThemeProvider theme={theme}>
        <GlobalStyled />
        <BodyContainer>
          <Header />
          <Suspense fallback={<div>loading...</div>}>
            <Routers />
          </Suspense>
        </BodyContainer>
      </ThemeProvider>
    </MuiThemeProvider>
  );
}

const BodyContainer = styled.div`
  width: 100%;
  height: 100%;
  padding: 40px 100px 0 100px;
`;

export default App;
