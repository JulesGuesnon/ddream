module.exports = {
    content: ["./src/**/*.res"],
    theme: {
        extend: {
            keyframes: {
                "spinner-dash": {
                    "0%": {
                        "stroke-dasharray": "1, 150",
                        "stroke-dashoffset": "0",
                    },
                    "50%": {
                        "stroke-dasharray": "90, 150",
                        "stroke-dashoffset": "-35",
                    },
                    "100%": {
                        "stroke-dasharray": "90, 150",
                        "stroke-dashoffset": "-124",
                    },
                },
                "spinner-rotate": {
                    "100%": { transform: "rotate(360deg)" },
                },
            },
            animation: {
                "spinner-dash": "spinner-dash 1.5s ease-in-out infinite",
                "spinner-rotate": "spinner-rotate 2s linear infinite",
            },
        },
    },
};
