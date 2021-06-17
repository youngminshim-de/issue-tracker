import CustomButton from "components/common/Button";
import React from "react";
import styled from "styled-components";
import Filter from "./Filter";
import { Box, ButtonGroup, Button } from "@material-ui/core";

export default function Nav() {
  return (
    <Box display="flex" justifyContent="space-between" mb={5}>
      <Box display="flex" flex="1" mr={3}>
        <Filter />
      </Box>
      <ButtonGroup>
        <Button>레이블 (3)</Button>
        <Button>마일스톤 (2)</Button>
      </ButtonGroup>
      <Box ml={3}>
        <CustomButton customColor="blue">+ 이슈작성</CustomButton>
      </Box>
    </Box>
  );
}

const NavWrapper = styled.div`
  display: flex;
  justify-content: space-between;
`;

const FilterBox = styled.div``;

const LabelAndMile = styled.div``;

const Labels = styled.div``;
const MileStones = styled.div``;

const ButtonBox = styled.div``;
