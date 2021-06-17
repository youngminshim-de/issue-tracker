import Nav from "./Nav";
import styled from "styled-components";
import ListCard from "components/common/ListCard";

export default function IssueMainPage() {
  return (
    <IssueMainPageWrapper>
      <Nav />
      <ListCard>
        <div>testHeader</div>
        <div>test</div>
        <div>test</div>
        <div>test</div>
        <div>test</div>
      </ListCard>
    </IssueMainPageWrapper>
  );
}

const IssueMainPageWrapper = styled.div``;
