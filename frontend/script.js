<script>
  const apiUrl = 'https://rayofvvjz4.execute-api.eu-west-2.amazonaws.com/prod/challenge';

  // Fetch a new coding challenge
  function getChallenge() {
    console.log('🔄 Get Challenge button clicked');
    const challengeElement = document.getElementById('challenge');
    challengeElement.textContent = 'Loading...';

    fetch(apiUrl)
      .then(res => {
        if (!res.ok) throw new Error('Network response was not ok');
        return res.json();
      })
      .then(data => {
        console.log('✅ Challenge received:', data);
        challengeElement.textContent = data.challenge;
      })
      .catch(err => {
        console.error('❌ Fetch error:', err);
        challengeElement.textContent = 'Failed to load challenge.';
      });
  }

  // Mark the current challenge as completed
  function markCompleted() {
    const challenge = document.getElementById('challenge').textContent;
    if (!challenge || challenge === 'Loading...' || challenge === 'Failed to load challenge.') {
      alert('No valid challenge to mark as completed.');
      return;
    }

    fetch(apiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ challenge })
    })
    .then(res => {
      if (!res.ok) throw new Error('Failed to mark challenge');
      return res.json();
    })
    .then(data => {
      console.log('✅ Challenge marked as completed:', data);
      alert('Challenge marked as completed!');
    })
    .catch(err => {
      console.error('❌ POST error:', err);
      alert('Failed to mark challenge.');
    });
  }

  // Attach event listeners after DOM loads
  document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('getChallengeBtn').addEventListener('click', getChallenge);
    document.getElementById('markCompletedBtn').addEventListener('click', markCompleted);
  });
</script>

