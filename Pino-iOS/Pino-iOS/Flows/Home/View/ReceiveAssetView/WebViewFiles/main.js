let timeout;

 function generateAndShowQRCode(qrCode) {
     clearTimeout(timeout)
         let qrCodeComponent = document.getElementById("qr1")
               qrCodeComponent.contents = qrCode
     
    timeout = setTimeout(() => {
     animateQRCode(qrCodeComponent)
     }, 0)

           }

function animateQRCode(qrCodeComponent) {
    qrCodeComponent.style = `${qrCodeComponent.style} display: block;`
    qrCodeComponent
    .animateQRCode((targets, _x, _y, _count, entity) => ({
      targets,
      from: entity === "module" ? Math.random() * 1000 : 500,
      duration: 400,
      web: {
        opacity: entity === "module" ? [0, 0.5, 0, 1] : [0, 1]
      }
    }));
}


