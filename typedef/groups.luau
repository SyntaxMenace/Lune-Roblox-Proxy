export type TypeGroup = {
    group: {
        name: string,
        id: number,

        memberCount: number,

        description: string,

        hasVerifiedBadge: boolean,
        isBuildersClubOnly: boolean,
        publicEntryAllowed: boolean,

        owner: {
            displayName: string,
            hasVerifiedBadge: boolean,
            userId: number,
            username: string
        },
    },
    role:  {
        name: string,
        rank: number,
        id: number,
    }
}

return {}