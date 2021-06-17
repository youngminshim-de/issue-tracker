import { Suspense } from "react";
import { ThemeProvider } from "styled-components";
import { theme } from "styles";
import {
  unstable_createMuiStrictModeTheme,
  ThemeProvider as MuiThemeProvider,
} from "@material-ui/core";
import GlobalStyled from "styles/GlobalStyled";
import Routers from "components/core/Routers";

const MuiTheme = unstable_createMuiStrictModeTheme();

function App() {
  return (
    <MuiThemeProvider theme={MuiTheme}>
      <ThemeProvider theme={theme}>
        <GlobalStyled />
        <Suspense fallback={<div>loading...</div>}>
          <Routers />
        </Suspense>
      </ThemeProvider>
    </MuiThemeProvider>
  );
}

export default App;
