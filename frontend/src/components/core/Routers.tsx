import { Route, Switch } from "react-router-dom";
import LoginPage from "../user/Login";
import IssueAppenderPage from "./Issue/Appender/IssueAppenderPage";
import SubPage from "./SubPage";
import IssueDetailPage from "./Issue/Detail/IssueDetailPage";
import IssueMainPage from "./Issue/Main/IssueMainPage";
import { BrowserRouter } from "react-router-dom";

export default function Routers() {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/" exact>
          <IssueMainPage />
        </Route>
        <Route path="/login">
          <LoginPage />
        </Route>
        <Route path="/appender">
          <IssueAppenderPage />
        </Route>
        <Route path="/sub">
          <SubPage />
        </Route>
        <Route path="/detail">
          <IssueDetailPage />
        </Route>
      </Switch>
    </BrowserRouter>
  );
}
