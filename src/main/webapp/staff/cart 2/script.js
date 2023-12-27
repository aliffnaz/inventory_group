// Select DOM elements
const cart = $('#cart'); 
const close = $('#cart-close');

// Click event for buttons
$('.addToCart').click(function() {

  // Show cart
  cart.addClass('active');

  // Get product details
  let product =  {
    id: 1,
    name: 'PRODUCT NAME 1',
    image: '1.PNG',
    price: 120000
};
// get details
  
  // Calculate
  let total = 0;
  let qty = 0;

  // Add product to cart
  // Update total

  // Display updated totals
}) 

// Close cart
close.click(function() {
  cart.removeClass('active');
})