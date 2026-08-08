// Real-time YouTube Streaming Datasets
const initialVideos = [
    { id: "dQw4w9WgXcQ", title: "Tutoriel Data Engineering Kafka & Snowflake", channel: "Tech Data Academy", category: "Science & Tech", views: 145200, likes: 11400, engagement: "8.8 %", sentimentScore: 0.88, sentimentLabel: "POSITIVE" },
    { id: "9bZkp7q19f0", title: "IA Générative et Big Data en 2026", channel: "Data World TV", category: "Science & Tech", views: 98400, likes: 7200, engagement: "7.9 %", sentimentScore: 0.82, sentimentLabel: "POSITIVE" },
    { id: "L_LUpnjgPso", title: "Architecture Snowflake Data Warehouse pour Débutants", channel: "Cloud Data Hub", category: "Éducation", views: 64100, likes: 5100, engagement: "8.4 %", sentimentScore: 0.91, sentimentLabel: "POSITIVE" },
    { id: "kJQP7kiw5Fk", title: "Top 5 Frameworks Big Data : Spark vs Flink vs Hive", channel: "Code & Bytes", category: "Éducation", views: 52000, likes: 3900, engagement: "7.5 %", sentimentScore: 0.65, sentimentLabel: "POSITIVE" },
    { id: "3JZ_D3ELwOQ", title: "Conférence Live : Scaling Real-Time Pipelines", channel: "Big Data Summit", category: "Événements", views: 38200, likes: 2100, engagement: "5.8 %", sentimentScore: 0.40, sentimentLabel: "NEUTRAL" }
];

let streamInterval = null;
let isStreaming = true;
let categoryChartInstance = null;
let sentimentChartInstance = null;

const sampleCommentsPool = [
    { author: "MarcData", text: "Excellente vidéo sur Kafka et Snowflake !", sentiment: "POSITIVE", score: 0.85 },
    { author: "SophieTech", text: "Explications très précises, merci pour le script SQL !", sentiment: "POSITIVE", score: 0.92 },
    { author: "User99", text: "Le son était un peu bas sur l'intro.", sentiment: "NEUTRAL", score: 0.10 },
    { author: "DevOps_Guru", text: "Très bonne démo du pipeline Hive et ORC.", sentiment: "POSITIVE", score: 0.78 }
];

document.addEventListener("DOMContentLoaded", () => {
    renderVideoTable(initialVideos);
    initCharts();
    startLiveTicker();
});

function renderVideoTable(videos) {
    const tbody = document.getElementById("videoTableBody");
    tbody.innerHTML = "";

    videos.forEach(v => {
        const badgeClass = v.sentimentLabel === "POSITIVE" ? "pos" : (v.sentimentLabel === "NEUTRAL" ? "neu" : "neg");
        const row = `
            <tr>
                <td><strong>${v.title}</strong><br><small style="color:#9ca3af">ID: ${v.id}</small></td>
                <td><i class="fa-brands fa-youtube" style="color:#ff0000"></i> ${v.channel}</td>
                <td><span style="background:rgba(255,255,255,0.08); padding:3px 8px; border-radius:6px; font-size:12px;">${v.category}</span></td>
                <td><strong>${v.views.toLocaleString()}</strong></td>
                <td>${v.likes.toLocaleString()}</td>
                <td><strong style="color:#34d399">${v.engagement}</strong></td>
                <td><span class="sentiment-badge ${badgeClass}">${v.sentimentLabel} (${v.sentimentScore})</span></td>
            </tr>
        `;
        tbody.innerHTML += row;
    });
}

function initCharts() {
    // 1. Chart Ingestion Vues par Catégorie
    const ctx1 = document.getElementById("categoryChart").getContext("2d");
    categoryChartInstance = new Chart(ctx1, {
        type: 'bar',
        data: {
            labels: ['Science & Tech', 'Éducation', 'Événements', 'Divertissement'],
            datasets: [{
                label: 'Vues Ingestion Stream',
                data: [243600, 116100, 38200, 61000],
                backgroundColor: ['#ef4444', '#3b82f6', '#10b981', '#f59e0b'],
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { grid: { color: 'rgba(255,255,255,0.05)' } },
                x: { grid: { display: false } }
            }
        }
    });

    // 2. Chart Sentiment Distribution
    const ctx2 = document.getElementById("sentimentChart").getContext("2d");
    sentimentChartInstance = new Chart(ctx2, {
        type: 'doughnut',
        data: {
            labels: ['Positif', 'Neutre', 'Négatif'],
            datasets: [{
                data: [84, 12, 4],
                backgroundColor: ['#10b981', '#f59e0b', '#ef4444'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom', labels: { color: '#f9fafb' } }
            }
        }
    });
}

function startLiveTicker() {
    const box = document.getElementById("tickerBox");
    streamInterval = setInterval(() => {
        if (!isStreaming) return;

        const now = new Date().toLocaleTimeString();
        const randComment = sampleCommentsPool[Math.floor(Math.random() * sampleCommentsPool.length)];
        const topic = Math.random() > 0.4 ? "youtube-comments-raw" : "youtube-videos-raw";

        let entryHTML = "";
        if (topic === "youtube-comments-raw") {
            entryHTML = `
                <div class="log-entry">
                    <span class="log-time">[${now}]</span>
                    <span class="log-topic">[${topic}]</span>
                    <span class="log-msg">Commentaire de @${randComment.author}: "${randComment.text}" (Sentiment: ${randComment.sentiment})</span>
                </div>
            `;
        } else {
            const addedViews = Math.floor(Math.random() * 150) + 10;
            entryHTML = `
                <div class="log-entry">
                    <span class="log-time">[${now}]</span>
                    <span class="log-topic">[${topic}]</span>
                    <span class="log-msg">Update métriques vidéo dQw4w9WgXcQ | +${addedViews} nouvelles vues ingérées.</span>
                </div>
            `;
            // Dynamic KPI increment
            const curViews = parseInt(document.getElementById("kpiViews").innerText.replace(/,/g, ''));
            document.getElementById("kpiViews").innerText = (curViews + addedViews).toLocaleString();
        }

        box.innerHTML = entryHTML + box.innerHTML;
    }, 2500);
}

function toggleStream() {
    isStreaming = !isStreaming;
    const btn = document.getElementById("playPauseIcon");
    const statusText = document.getElementById("streamStatusText");

    if (isStreaming) {
        btn.className = "fa-solid fa-pause";
        statusText.innerText = "Kafka Producer: ACTIF";
    } else {
        btn.className = "fa-solid fa-play";
        statusText.innerText = "Kafka Producer: PAUSE";
    }
}

function filterVideos() {
    const query = document.getElementById("searchInput").value.toLowerCase();
    const rows = document.querySelectorAll("#videoTableBody tr");

    rows.forEach(r => {
        const text = r.innerText.toLowerCase();
        r.style.display = text.includes(query) ? "" : "none";
    });
}
