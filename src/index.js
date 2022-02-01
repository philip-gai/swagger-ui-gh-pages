import SwaggerUI from "swagger-ui";
import StandalonePreset from 'swagger-ui/dist/swagger-ui-standalone-preset'
import "swagger-ui/dist/swagger-ui.css";

SwaggerUI({
  dom_id: "#swagger-ui",
  configUrl: "src/swagger-config.json",
  presets: [
    SwaggerUI.presets.apis,
    StandalonePreset
  ],
  layout: "StandaloneLayout"
});
