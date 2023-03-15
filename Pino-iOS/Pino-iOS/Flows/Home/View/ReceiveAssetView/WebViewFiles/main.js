

function generateAndShowQRCode(qrCode) {
               let qrCodeComponent = document.getElementById("qr1")
               qrCodeComponent.contents = qrCode
    setTimeout(() => {
            animateQRCode(qrCodeComponent)
    } , 20)
           }
function animateQRCode(qrCodeComponent) {
    qrCodeComponent.style = `${qrCodeComponent.style} display: block;`
    qrCodeComponent
    .animateQRCode((targets, _x, _y, _count, entity) => ({
      targets,
      from: entity === "module" ? Math.random() * 1000 : 500,
      duration: 1000,
      web: {
        opacity: entity === "module" ? [0, 0.5, 0, 1] : [0, 1]
      }
    }));
}


