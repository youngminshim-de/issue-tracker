import { createGlobalStyle } from "styled-components";
import reset from "styled-reset";

export default createGlobalStyle`
    ${reset}
    * {
        box-sizing: border-box;
    }
    html {
        height: 100%;
    }
    body  {
        background: #f2f2f2;
        font-family : 'Noto Sans KR';
        height: 100%;
    }
    a {}
`;
