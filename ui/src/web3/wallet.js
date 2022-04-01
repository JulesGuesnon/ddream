const wallet = {
    METAMASK: "METAMASK",
};

export const metamask = {
    id: wallet.METAMASK,
    name: "Metamask",
    provider: window.ethereum,
    enable: () => {
        if (!window.ethereum)
            return Promise.reject(new Error("Window Ethereum is undefined"));

        return window.ethereum.request({
            method: "eth_requestAccounts",
        });
    },
};
