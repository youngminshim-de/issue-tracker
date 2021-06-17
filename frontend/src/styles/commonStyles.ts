import { css } from "styled-components";

export const FLEX = {
  CENTER: css`
    display: flex;
    justify-content: center;
    align-items: center;
  `,
  CENTER_COLUMN: css`
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  `,
};

export const BUTTON = {
  M: css`
    width: 120px;
    height: 40px;
    border-radius: 10px;
  `,
  L: css`
    width: 240rem;
    height: 56px;
    border-radius: 16px;
  `,
  FULL: css`
    width: 100%;
    height: 40px;
    border-radius: 10px;
  `,
};
