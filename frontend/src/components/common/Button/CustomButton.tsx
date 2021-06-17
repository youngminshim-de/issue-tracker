import { Box, Button, ButtonProps } from "@material-ui/core";
import styled, { css } from "styled-components";

interface CustomButtonProps extends ButtonProps {
  children: React.ReactNode;
  customColor?: string;
  customSize?: string;
  fontWeight?: string;
}

export default function CustomButton({
  children,
  customColor,
  customSize,
  fontWeight,
  ...props
}: CustomButtonProps) {
  return (
    <Box>
      <CustomButtonBox {...props} {...{ customColor, customSize, fontWeight }}>
        {children}
      </CustomButtonBox>
    </Box>
  );
}

interface CustomButtonBoxProps {
  customColor?: string;
  customSize?: string;
  fontWeight?: string;
}

const CustomButtonBox = styled(Button)<CustomButtonBoxProps>`
  ${({ theme, customColor, customSize, fontWeight }) => css`
    ${customColor &&
    css`
      ${theme.COLOR[customColor]};
    `}
    ${customSize &&
    css`
      ${theme.SIZE[customSize]};
    `}
    ${fontWeight &&
    css`
      font-weight: ${theme.FONT_WEIGHT[fontWeight]};
    `}
  `};
`;
