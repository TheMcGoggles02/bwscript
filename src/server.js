import express from "express";
import pkg from 'puppeteer';

// Constants
const PORT = 80;
const HOST = "0.0.0.0";

// App
const app = express();
app.listen(PORT, HOST);

app.get("/", (req, res) => {
  res.send("Hello\n");
});

app.get("/bwscript", async (req, res, next) => {
  try {
  const browser = await pkg.launch({ args: ["--no-sandbox"] });
  const page = await browser.newPage();

  await gotoPage(
    page,
    "https://qa.qsrqa.io/full/0b1c7b35-e74c-42cb-9bbd-683e662d10c5/waitList?displayBackButton=true"
  );
  await page.waitForSelector('.qsr-compound-button-forward', { visible: true });
  await page.click('.qsr-compound-button-forward');
  await delay(1000);
  const firstName = await page.$('[placeholder="First"]');
  await firstName.type("Michael");
  const lastName = await page.$('[placeholder="Last"]');
  await lastName.type("McCullough");
  const phoneNumber = await page.$('[placeholder="Phone Number"]');
  await phoneNumber.type("5025555555");
  const checkbox = await page.$(".qsr-checkbox");
  await checkbox.click();
  await page.waitForSelector('.qsr-compound-button-forward', { visible: true });
  await page.click('.qsr-compound-button-forward');
  await delay(1000);
  const buttonClick3 = await page.$(".qsr-btn-primary");
  await buttonClick3.click();
  await delay(1000);

  browser.close();

  res.send("success");
  } catch (err) {
    next(err);
  }
});

function delay(time) {
  return new Promise(function(resolve) { 
      setTimeout(resolve, time)
  });
}

async function gotoPage(page, url) {
  try {
  await page.setViewport({ width: 1920, height: 1080 });
  await page.setDefaultNavigationTimeout(0);

  await page.goto(url);
  await page.waitFor(2000);
  } catch (err) {
    next(err);
  }
  //   await page.screenshot({ path: 'screenshots/'+ url.split(".")[1] + '.png' });

  return page;
}
