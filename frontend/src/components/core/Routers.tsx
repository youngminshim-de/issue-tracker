import { Route, Switch } from "react-router-dom";
import LoginPage from "../user/Login";
import IssueAppenderPage from "./Issue/Appender";
import IssueDetailPage from "./Issue/Detail";
import IssueMainPage from "./Issue/Main";
import MileStones from "./MileStones";
import Labels from "./Labels";
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
          <Route path="/labels">
            <Labels />
          </Route>
          <Route path="/milestones">
            <MileStones />
          </Route>
          <Route path="/detail">
            <IssueDetailPage />
          </Route>
        </Switch>
    </BrowserRouter>
  );
}

