class Rectangle
{
  public Vector3 position;
  public Vector3 size;
  public RGB rgb;

  // Momentum
  public float hu;

  // Height derivative
  public float dhdt;      

  // Momentum derivative
  public float dhudt;     

  // Height(midpoint)
  public float h_mid;     
  
  // Momentum(midpoint)
  public float hu_mid;    
  
  // Height derivative(midpoint)
  public float dhdt_mid;  
  
  // Momentum derivative (midpoint)
  public float dhudt_mid; 
  
  Rectangle(Vector3 position, Vector3 size, RGB rgb){
    this.position = position;
    this.size = size;
    this.rgb = rgb;
  }
}