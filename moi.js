    // NAV AUTO-DETECTION
    document.addEventListener('DOMContentLoaded', function() {
      const liensNav = document.querySelectorAll('nav a');
      const pageActuelle = window.location.pathname.split('/').pop() || 'index.html';
      liensNav.forEach(lien => {
        if (lien.getAttribute('href') === pageActuelle) {
          lien.classList.add('active');
        }
      });
    });

    // MODAL CV
    function ouvrirCV() {
      document.getElementById('modalCV').classList.add('active');
    }
    
    function fermerCV() {
      document.getElementById('modalCV').classList.remove('active');
    }

    