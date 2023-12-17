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
    let response = await fetch("https://3dis7dqsewcouos6wnmikckt4e0fabft.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = ` Views: ${data}`;
}
updateCounter()