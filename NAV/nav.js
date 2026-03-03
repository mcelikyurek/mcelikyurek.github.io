document.addEventListener('DOMContentLoaded', function() {
  const liensNav = document.querySelectorAll('nav a');
  const pageActuelle = window.location.pathname.split('/').pop() || '/index.html';
  
  liensNav.forEach(lien => {
    const href = lien.getAttribute('href');
    
    // Si le href correspond à la page actuelle
    if (href === pageActuelle) {
      lien.classList.add('active');
    }
  });
});