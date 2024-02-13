var typed = new Typed('#typed', {
    strings: [
        'Financial Analyst',
        'Cloud Engineer'
    ],
    typeSpeed: 50,
    backSpeed: 50,
    loop: true
});

const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch("https://qx4i3eeoc6qh7jhnugieqi4bue0btyux.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = ` Views: ${data}`;
}
updateCounter()