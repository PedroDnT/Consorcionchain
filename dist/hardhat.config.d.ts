import "@nomicfoundation/hardhat-verify";

export let defaultNetwork: string;
export namespace networks {
    let hardhat: {};
    namespace lachain {
        let url: string;
        let accounts: (string | undefined)[];
    }
    namespace laTestnet {
        let url_1: string;
        export { url_1 as url };
        export let chainId: number;
        let accounts_1: (string | undefined)[];
        export { accounts_1 as accounts };
    }
}
export namespace solidity {
    let version: string;
    namespace settings {
        namespace optimizer {
            let enabled: boolean;
            let runs: number;
        }
    }
}
export namespace paths {
    let sources: string;
    let tests: string;
    let cache: string;
    let artifacts: string;
}
export namespace mocha {
    let timeout: number;
}
export namespace sourcify {
    let enabled_1: boolean;
    export { enabled_1 as enabled };
    export let apiUrl: string;
    export let browserUrl: string;
}
