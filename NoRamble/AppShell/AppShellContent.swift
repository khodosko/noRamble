struct AppShellContent: Equatable, Sendable {
    let title: String
    let status: String

    static let foundation = AppShellContent(
        title: "No Ramble",
        status: "Ready for the first daily practice slice"
    )
}
