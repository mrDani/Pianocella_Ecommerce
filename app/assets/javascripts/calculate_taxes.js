document.addEventListener("DOMContentLoaded", function () {
    console.log("✅ JavaScript Loaded Successfully");
  
    function calculateTaxes() {
      const provinceSelect = document.getElementById('province-select');
      const totalPriceElement = document.getElementById('total-price');
      const pstElement = document.getElementById('pst');
      const gstElement = document.getElementById('gst');
      const hstElement = document.getElementById('hst');
      const totalWithTaxesElement = document.getElementById('total-with-taxes');
  
      if (!provinceSelect || !totalPriceElement || !pstElement || !gstElement || !hstElement || !totalWithTaxesElement) {
        console.error("❌ Required elements are missing from the DOM.");
        return;
      }
  
      const province = provinceSelect.value;
      const baseTotal = parseFloat(totalPriceElement.innerText) || 0.0;
  
      let pst = 0, gst = 0, hst = 0;
  
      switch (province) {
        case 'Ontario':
          hst = baseTotal * 0.13;
          break;
  
        case 'Nova Scotia':
          hst = baseTotal * 0.14; // As of April 1, 2025
          break;
  
        case 'New Brunswick':
        case 'Newfoundland and Labrador':
        case 'Prince Edward Island':
          hst = baseTotal * 0.15;
          break;
  
        case 'British Columbia':
          pst = baseTotal * 0.07;
          gst = baseTotal * 0.05;
          break;
  
        case 'Manitoba':
          pst = baseTotal * 0.07;
          gst = baseTotal * 0.05;
          break;
  
        case 'Saskatchewan':
          pst = baseTotal * 0.06;
          gst = baseTotal * 0.05;
          break;
  
        case 'Quebec':
          pst = baseTotal * 0.09975;
          gst = baseTotal * 0.05;
          break;
  
        case 'Alberta':
          gst = baseTotal * 0.05;
          break;
  
        case 'Northwest Territories':
        case 'Nunavut':
        case 'Yukon':
          gst = baseTotal * 0.05;
          break;
  
        default:
          gst = baseTotal * 0.05;
      }
  
      const totalWithTaxes = baseTotal + pst + gst + hst;
  
      pstElement.innerText = pst.toFixed(2);
      gstElement.innerText = gst.toFixed(2);
      hstElement.innerText = hst.toFixed(2);
      totalWithTaxesElement.innerText = totalWithTaxes.toFixed(2);
  
      console.log("✅ Tax calculation updated", { province, pst, gst, hst, totalWithTaxes });
    }
  
    requestAnimationFrame(() => {
      const provinceSelect = document.getElementById('province-select');
      if (provinceSelect) {
        provinceSelect.addEventListener('change', calculateTaxes);
        if (provinceSelect.value && provinceSelect.value !== "") {
          console.log("🌟 Triggering tax calculation on page load for:", provinceSelect.value);
          calculateTaxes();
        }
      }
    });
  });
  