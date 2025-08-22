fetch('https://your-api-gateway-url/challenge')
  .then(res => res.json())
  .then(data => {
    document.getElementById('challenge').textContent = data.challenge;
  });

