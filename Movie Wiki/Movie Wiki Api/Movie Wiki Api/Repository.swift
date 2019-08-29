import Moya

extension MoyaProvider {
    public static var theMovieDb: MoyaProvider<TheMovieDb> {
        return MoyaProvider<TheMovieDb>(plugins: [MoyaCacheablePlugin()])
    } 
}
