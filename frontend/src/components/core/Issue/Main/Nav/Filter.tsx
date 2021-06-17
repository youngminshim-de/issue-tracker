import React from "react";
import styled from "styled-components";
import { Box, TextField, Input } from "@material-ui/core";

export default function Filter() {
  return (
    <Box
      display="flex"
      alignItems="center"
      width="100%"
      borderRadius="10px"
      border="1px solid #cfcfd8"
    >
      <Box width="5rem">필터</Box>
      <Box flex="1">
        <Input
          disableUnderline
          id="searchFilter"
          placeholder="is:open"
          type="text"
          fullWidth
        ></Input>
      </Box>
    </Box>
  );
}
