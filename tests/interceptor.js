import axios from "axios";

// Create an Axios instance
const apiClient = axios.create({
  baseURL: "https://api.elroi-shoppin.com", // Replace with your API's base URL
  timeout: 5000, // Request timeout in milliseconds
  headers: {
    "Content-Type": "application/json",
  },
});

// Request Interceptor
apiClient.interceptors.request.use(
  (config) => {
    // Add Authorization token if available
    const token = localStorage.getItem("authToken"); // Assuming token is stored in localStorage
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    console.log("Request Config:", config); // For debugging purposes
    return config;
  },
  (error) => {
    // Handle request errors
    console.error("Request Error:", error);
    return Promise.reject(error);
  }
);

// Response Interceptor
apiClient.interceptors.response.use(
  (response) => {
    // Any response-level handling (e.g., logging, modifying response data)
    console.log("Response Data:", response.data); // For debugging
    return response;
  },
  (error) => {
    // Handle response errors
    if (error.response) {
      // Log specific HTTP status errors
      console.error("Response Error:", error.response);
      if (error.response.status === 401) {
        // Handle unauthorized access (e.g., redirect to login)
        console.error("Unauthorized! Redirecting to login...");
        window.location.href = "/login"; // Adjust the path as needed
      }
    } else {
      console.error("Network or Server Error:", error.message);
    }
	  return Promise.reject(error);
  }
);

export default apiClient;
