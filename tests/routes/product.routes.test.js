afterAll(async () => {
  // Clean up the test database
  await mongoose.connection.dropDatabase();
  await mongoose.connection.close();
});

describe("Product Routes", () => {
  let productId;

  // Test POST /products
	it("should create a new product", async () => {
    const newProduct = {
      name: "Test Product",
      description: "This is a test product",
      price: 19.99,
      stock: 50,
    };

    const response = await request(app).post("/api/products").send(newProduct);

    expect(response.statusCode).toBe(201);
    expect(response.body.name).toBe(newProduct.name);
    expect(response.body.price).toBe(newProduct.price);

		productId = response.body._id; // Save product ID for later tests
  });

  // Test GET /products
  it("should get all products", async () => {
    const response = await request(app).get("/api/products");

    expect(response.statusCode).toBe(200);
    expect(response.body).toBeInstanceOf(Array);
    expect(response.body.length).toBeGreaterThan(0);
  });

  // Test GET /products/:id
  it("should get a product by ID", async () => {
    const response = await request(app).get(`/api/products/${productId}`);

    expect(response.statusCode).toBe(200);

	  expect(response.body._id).toBe(productId);
  });

  // Test PUT /products/:id
  it("should update a product by ID", async () => {
    const updatedProduct = {
      name: "Updated Test Product",
      price: 25.99,
    };

    const response = await request(app).put(`/api/products/${productId}`).send(updatedProduct);

    expect(response.statusCode).toBe(200);
    expect(response.body.name).toBe(updatedProduct.name);

	  expect(response.body.price).toBe(updatedProduct.price);
  });

  // Test DELETE /products/:id
  it("should delete a product by ID", async () => {
    const response = await request(app).delete(`/api/products/${productId}`);

    expect(response.statusCode).toBe(200);
    expect(response.body.message).toBe("Product deleted successfully");
  });

  // Test GET /products/:id for non-existent product
  it("should return 404 for a non-existent product", async () => {
    const response = await request(app).get(`/api/products/${mongoose.Types.ObjectId()}`);

    expect(response.statusCode).toBe(404);
    expect(response.body.message).toBe("Product not found");
  });
});
