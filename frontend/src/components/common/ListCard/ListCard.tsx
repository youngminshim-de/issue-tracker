import React from "react";
import styled from "styled-components";

interface ListProps {
  children: React.ReactNode;
}

export default function ListCard({ children }: ListProps) {
  if (!children) return <ListWrapper></ListWrapper>;

  if (Array.isArray(children)) {
    return (
      <ListWrapper>
        <ListHeader>{children[0]}</ListHeader>
        {children.slice(1).map((el) => (
          <ListItem>{el}</ListItem>
        ))}
      </ListWrapper>
    );
  } else {
    return <ListHeader>{children}</ListHeader>;
  }
}

const ListWrapper = styled.div`
  border: 1px solid #cfcfd8;
  border-radius: 10px;
  overflow: hidden;
`;

const ListHeader = styled.div`
  background: #f7f7fc;
  padding: 0.7em 1em;
`;

const ListItem = styled.div`
  border-top: 1px solid #cfcfd8;
  background: white;
  padding: 0.7em 1em;
`;
