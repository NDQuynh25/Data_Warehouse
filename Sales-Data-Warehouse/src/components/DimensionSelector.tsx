import React from "react";
import {
  Box,
  Checkbox,
  FormGroup,
  FormControlLabel,
  Collapse,
  Typography,
} from "@mui/material";

type DimensionsState = {
  [key: string]: {
    show: boolean;
    columns?: { [key: string]: boolean };
  };
};

interface DimensionsSelectorProps {
  dimensions: DimensionsState;
  setDimensions: React.Dispatch<React.SetStateAction<DimensionsState>>;
}

function toTitleCaseWithSpaces(text: string): string {
  const result = text
    .replace(/([A-Z])/g, " $1")
    .replace(/_/g, " ")
    .toLowerCase();

  return result.replace(/\b\w/g, (char) => char.toUpperCase()).trim();
}

const DimensionsSelector: React.FC<DimensionsSelectorProps> = ({
  dimensions,
  setDimensions,
}) => {
  return (
    <Box>
      <Typography variant="h6" gutterBottom>
        Chọn Chiều
      </Typography>
      <FormGroup>
        {Object.entries(dimensions).map(([dimKey, dimValue]) => (
          <Box key={dimKey} mb={2}>
            <FormControlLabel
              control={
                <Checkbox
                  checked={dimValue.show}
                  onChange={(e) =>
                    setDimensions((prev) => ({
                      ...prev,
                      [dimKey]: {
                        ...prev[dimKey],
                        show: e.target.checked,
                      },
                    }))
                  }
                />
              }
              label={toTitleCaseWithSpaces(dimKey)}
            />
            {"columns" in dimValue && dimValue.show && (
              <Collapse in={dimValue.show} timeout="auto" unmountOnExit>
                <Box sx={{ ml: 3, mt: 1 }}>
                  <FormGroup>
                    {Object.entries(dimValue.columns!).map(
                      ([colKey, checked]) => {
                        let marginLeft = 0;

                        if (dimKey === "time") {
                          if (colKey === "quarter") marginLeft = 2;
                          if (colKey === "month") marginLeft = 4;
                        }
                        if (dimKey === "location") {
                          if (colKey === "city") marginLeft = 2;
                        }
                        if (dimKey === "customer") {
                          if (colKey === "customerKey") marginLeft = 2;
                        }

                        // Lấy trạng thái của 'state' trong location (nếu có)
                        const stateChecked =
                          dimKey === "location"
                            ? dimValue.columns?.state ?? false
                            : true; // Với dimension khác thì không disable

                        const handleChange = (
                          e: React.ChangeEvent<HTMLInputElement>
                        ) => {
                          const checked = e.target.checked;
                          setDimensions((prev) => ({
                            ...prev,
                            [dimKey]: {
                              ...prev[dimKey],
                              columns: {
                                ...prev[dimKey].columns,
                                [colKey]: checked,
                              },
                            },
                          }));
                        };

                        return (
                          <FormControlLabel
                            key={colKey}
                            control={
                              <Checkbox
                                checked={checked}
                                onChange={handleChange}
                                disabled={
                                  dimKey === "location" &&
                                  colKey === "city" &&
                                  !stateChecked
                                }
                              />
                            }
                            label={toTitleCaseWithSpaces(colKey)}
                            sx={{ ml: marginLeft }}
                          />
                        );
                      }
                    )}
                  </FormGroup>
                </Box>
              </Collapse>
            )}
          </Box>
        ))}
      </FormGroup>
    </Box>
  );
};

export default DimensionsSelector;
