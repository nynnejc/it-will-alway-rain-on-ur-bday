int cols, rows;
int scl = 5; // Scale of the cloud "pixels"
float zoff = 0.0; // Offset for Perlin noise
boolean isAnimating = false; // Flag to check if the animation is active
int lastMouseX = -1; // Last mouse X position
int lastMouseY = -1; // Last mouse Y position
int lastMoveTime = 0; // Time of the last mouse movement
int stopDelay = 500; // Time in milliseconds before stopping animation

// Color variables
float baseR, baseG, baseB; // Base background color
float targetR, targetG, targetB; // Target color under the mouse
float yellowR = 255, yellowG = 255, yellowB = 204; // Pastel yellow color
float colorSpeed = 0.01; // Speed of color transition
float gradientRadius = 650; // Radius of the color gradient effect

void setup() {
  size(1400, 800); // Set the window size
  cols = width / scl;
  rows = height / scl;
  
  // Initialize background colors
  setBaseBackgroundColor();
}

void draw() {
  // Calculate the current color based on mouse position
  float mouseRatioX = map(mouseX, 0, width, 0, 1);
  float mouseRatioY = map(mouseY, 0, height, 0, 1);
  
  // Smoothly transition the background color
  baseR = lerp(baseR, targetR, colorSpeed);
  baseG = lerp(baseG, targetG, colorSpeed);
  baseB = lerp(baseB, targetB, colorSpeed);
  
  // Apply the radial gradient effect
  applyRadialGradient(mouseX, mouseY);
  
  // Check if the mouse has moved
  if (mouseX != lastMouseX || mouseY != lastMouseY) {
    lastMouseX = mouseX;
    lastMouseY = mouseY;
    lastMoveTime = millis();
    isAnimating = true; // Start or continue animation

    // Update target colors based on mouse position
    targetR = map(mouseRatioX, 0, 1, 200, 255);
    targetG = map(mouseRatioY, 0, 1, 180, 255);
    targetB = map(mouseRatioX + mouseRatioY, 0, 2, 200, 255);
  } else {
    // Stop animation if the mouse has been stationary for the stopDelay period
    if (millis() - lastMoveTime > stopDelay) {
      isAnimating = false;
    }
  }

  // Draw the clouds based on the current zoff value
  drawClouds();
  
  // Update zoff only if animation is active
  if (isAnimating) {
    zoff += 0.01; // Cloud movement speed
  }
}

// Function to apply radial gradient effect with three colors
void applyRadialGradient(float cx, float cy) {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float distance = dist(x, y, cx, cy);
      float intensity = constrain(map(distance, 0, gradientRadius, 1, 0), 0, 1);

      // Interpolate between base color, target color, and pastel yellow
      float r1 = lerp(baseR, targetR, intensity);
      float g1 = lerp(baseG, targetG, intensity);
      float b1 = lerp(baseB, targetB, intensity);

      // Blend with pastel yellow
      float r = lerp(r1, yellowR, 0.5 * intensity);
      float g = lerp(g1, yellowG, 0.5 * intensity);
      float b = lerp(b1, yellowB, 0.5 * intensity);
      
      int c = color(r, g, b);
      pixels[x + y * width] = c;
    }
  }
  updatePixels();
}

// Function to draw clouds
void drawClouds() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      float xoff = x * 0.05;
      float yoff = y * 0.05;
      float noiseValue = noise(xoff, yoff, zoff);

      if (noiseValue > 0.5) {
        float bright = map(noiseValue, 0.5, 1, 220, 255);
        noStroke();
        fill(bright);
        rect(x * scl, y * scl, scl, scl);
      }
    }
  }
}

// Function to set a random base background color
void setBaseBackgroundColor() {
  baseR = random(180, 255);
  baseG = random(180, 255);
  baseB = random(180, 255);
}
