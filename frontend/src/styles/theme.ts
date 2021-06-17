import { css } from "styled-components";

export const theme = {
  COLOR: {
    black: css`
      background: #14142b;
      color: white;
      :hover {
        background: #04041b;
      }
    `,
    lightBlue: css`
      background: #c7ebff;
      color: white;
      :hover {
        background: #91bfd8;
      }
    `,
    blue: css`
      background: #007aff;
      color: white;
      :hover {
        background: #004fa3;
      }
    `,
    darkBlue: css`
      background: #004de3;
      color: white;
      :hover {
        background: #00308f;
      }
    `,
    red: css`
      background: #ff3b30;
      color: white;
      :hover {
        background: #a31c15;
      }
    `,
    purple: css`
      background: #0025e7;
      color: white;
      :hover {
        background: #041c94;
      }
    `,
    lightPurple: css`
      background: #ccd4ff;
      color: white;
      :hover {
        background: #828cc3;
      }
    `,
  },
  FONT_WEIGHT: {
    normal: "400",
    bold: "700",
    extraBold: "900",
  },
  SIZE: {
    S: css`
      font-size: 0.75rem;
      height: 3rem;
      padding: 0 2rem;
    `,
    M: css`
      font-size: 1rem;
      height: 3.5rem;
      padding: 0 2rem;
    `,
    L: css`
      font-size: 1.5rem;
      height: 4.5rem;
      padding: 0 2rem;
    `,
  },
};
