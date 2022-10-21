# Cloth and Fluid Simulation

CSCI 5611 Project 2

@Author: 
- Akar (Ace) Kaung 
- Chanyoung (David) Cheong

Language: Processing

## Summary
The code inside this repo implements 2 simulations; Cloth, and Fluid. The cloth can collide with obstacle and change shape as in real life. As for the fluid, if something were to drop inside, it will start the waves.

## Cloth Simulation

- Multiple Ropes
  - As seen in the video below, there are multiple ropes attached to each other.

https://user-images.githubusercontent.com/76828992/197096991-bf028a13-1423-42d2-8825-e656f715cdca.mp4

- Cloth Simulation
  - Multiple ropes (vertically and horizontally) were attached to each others to form a cloth. Each string between nodes are vertically and horizontally connected. The gap between nodes are narrowed down to have densed cloth. As interpolating nodes between nodes, cloth looks natural with the obastacle
- 3D Simulation
  - The scene is render in 3D environment where user can move around 
- High-quality Rendering
  - The cloth uses real life texture to make it look good
- User Interaction
  - User can move the obstacle as well as the camera around. The obstacle can be moving around or through the cloth by user inputs.
 
https://user-images.githubusercontent.com/76828992/197096573-77a2bfca-0a2b-4ed7-aac7-8c95e9cb1db9.mp4

- Air Drag
  - In the video, without the air drag force, the cloth move back to its original position right away while with the air drag force, it looks like there's air resistance on it.

https://user-images.githubusercontent.com/76828992/197098678-fab38484-d485-4643-a7da-64baf86fdd7b.mp4

## Fluid
### PDE-based Fluid Simulation
Pool based water fluid simulation.

https://user-images.githubusercontent.com/76828992/197099927-e03eb14f-cec7-46c7-accc-9388d3d01d42.mp4

## Encountered challenges
- Texturizing the cloth is a bit challenging when the U and V values were not mentioned in the documentation of processing on how to calculate it.

### Outside resources (Credits)
#### Texture
- Cloth: <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@Link: https://cdn.shopify.com/s/files/1/2454/1459/products/DREAMDR-02RED_5a0c2fff-d2d3-4a34-906e-9e868bc016eb.jpg?v=1508036643
