const request = require('supertest'); // HTTP testing
const app = require('../app'); // Express application
const Product = require('../models/product.model'); // Product model

// Mock Product model
jest.mock('../models/product.model');

describe('Product Controller Tests for Children Categories', () => {
  afterEach(() => {
    jest.clearAllMocks(); // Clear mocks after each test
  });

  const mockProducts = [
    { _id: '1', name: 'Kids T-shirt', category: 'clothes', price: 20 },
    { _id: '2', name: 'Lego Set', category: 'toys', price: 50 },
    { _id: '3', name: 'School Bag', category: 'back-to-school', price: 35 },
    { _id: '4', name: 'Pencils Pack', category: 'stationeries', price: 5 },
    { _id: '5', name: 'Kids Sneakers', category: 'shoes', price: 40 },
  ];

  describe('GET /products', () => {
    it('should return all products', async () => {
      Product.find.mockResolvedValue(mockProducts);

      const response = await request(app).get('/products');
      expect(response.status).toBe(200);
      expect(response.body).toEqual(mockProducts);
      expect(Product.find).toHaveBeenCalledTimes(1);
    });

    it('should return products filtered by category', async () => {
    const filteredProducts = mockProducts.filter(p => p.category === 'toys');
      Product.find.mockResolvedValue(filteredProducts);

      const response = await request(app).get('/products?category=toys');
      expect(response.status).toBe(200);
      expect(response.body).toEqual(filteredProducts);
      expect(Product.find).toHaveBeenCalledWith({ category: 'toys' });
    });
  });

  describe('POST /products', () => {
    it('should create a new product in a specific category', async () => {
      const newProduct = { _id: '6', name: 'Coloring Book', category: 'stationeries', price: 8 };

      Product.create.mockResolvedValue(newProduct);

      const response = await request(app).post('/products').send({
        name: 'Coloring Book',
        category: 'stationeries',
        price: 8,
      });

      expect(response.status).toBe(201);
      expect(response.body).toEqual(newProduct);
      expect(Product.create).toHaveBeenCalledWith({
        name: 'Coloring Book',
        category: 'stationeries',
        price: 8,
      });
    });

    it('should return 400 if required fields are missing', async () => {
      Product.create.mockRejectedValue(new Error('Validation error'));

      const response = await request(app).post('/products').send({
        category: 'toys',
	price: 10, // Missing name
      });

      expect(response.status).toBe(400);
      expect(response.body.error).toBe('Validation error');
      expect(Product.create).toHaveBeenCalledTimes(1);
    });
  });

  describe('GET /products/:id', () => {
    it('should return a product by ID', async () => {
      const product = mockProducts[0];
      Product.findById.mockResolvedValue(product);

      const response = await request(app).get(`/products/${product._id}`);
      expect(response.status).toBe(200);
      expect(response.body).toEqual(product);
      expect(Product.findById).toHaveBeenCalledWith(product._id);
    });

    it('should return 404 if product not found', async () => {
      Product.findById.mockResolvedValue(null);

      const response = await request(app).get('/products/999');
      expect(response.status).toBe(404);
      expect(response.body.error).toBe('Product not found');
    });
  });

  describe('PUT /products/:id', () => {
    it('should update a product', async () => {
      const updatedProduct = { _id: '1', name: 'Kids T-shirt - Updated', category: 'clothes', price: 25 };
      Product.findByIdAndUpdate.mockResolvedValue(updatedProduct);

      const response = await request(app).put('/products/1').send({
        name: 'Kids T-shirt - Updated',
        price: 25,
      });

      expect(response.status).toBe(200);
      expect(response.body).toEqual(updatedProduct);
      expect(Product.findByIdAndUpdate).toHaveBeenCalledWith(
        '1',
        { name: 'Kids T-shirt - Updated', price: 25 },
        { new: true }
      );
    });

    it('should return 404 if product not found', async () => {
      Product.findByIdAndUpdate.mockResolvedValue(null);

      const response = await
      request(app).put('/products/999').send({
        name: 'Non-existent Product',
        price: 50,
      });

      expect(response.status).toBe(404);
      expect(response.body.error).toBe('Product not found');
    });
  });

  describe('DELETE /products/:id', () => {
    it('should delete a product by ID', async () => {
      Product.findByIdAndDelete.mockResolvedValue(true);

      const response = await request(app).delete('/products/1');
      expect(response.status).toBe(204); // No content
      expect(Product.findByIdAndDelete).toHaveBeenCalledWith('1');
    });

    it('should return 404 if product not found', async () => {
      Product.findByIdAndDelete.mockResolvedValue(null);

      const response = await request(app).delete('/products/999');send({
        name: 'Non-existent Product',
        price: 50,
      });

      expect(response.status).toBe(404);
      expect(response.body.error).toBe('Product not found');
    });
  });

  describe('DELETE /products/:id', () => {
    it('should delete a product by ID', async () => {
      Product.findByIdAndDelete.mockResolvedValue(true);

      const response = await request(app).delete('/products/1');
      expect(response.status).toBe(204); // No content
      expect(Product.findByIdAndDelete).toHaveBeenCalledWith('1');
    });

    it('should return 404 if product not found', async () => {
      Product.findByIdAndDelete.mockResolvedValue(null);

      const response = await request(app).delete('/products/999');,
      expect(response.status).toBe(404);
      expect(response.body.error).toBe('Product not found');
    });
  });
});
