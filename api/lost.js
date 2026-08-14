let lostUntil = 0;

export default function handler(request, response) {
  response.setHeader("Access-Control-Allow-Origin", "*");
  response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  response.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (request.method === "OPTIONS") {
    response.status(200).end();
    return;
  }

  if (request.method === "POST") {
    const body =
      typeof request.body === "string"
        ? JSON.parse(request.body || "{}")
        : request.body || {};
    lostUntil = body.lost === false ? 0 : Date.now() + 30 * 60 * 1000;
  }

  response.status(200).json({
    lost: Date.now() < lostUntil,
    until: lostUntil || null,
  });
}
