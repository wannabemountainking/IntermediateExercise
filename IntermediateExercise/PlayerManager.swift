//
//  PlayerManager.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/17/26.
//

import SwiftUI
import Combine

/*
 Song 구조체:
 - title: String
 - artist: String?
 - duration: Int (초 단위)
 - genre: String
 - playCount: Int
 */
struct Song: Identifiable {
    let id = UUID()
    let title: String
    var artist: String?
    let duration: Int
    let genre: String
    var playCount: Int
    
    
    // 2. map: 모든 곡의 재생시간을 "분:초" 형식으로 변환
    var durationWithFormat: String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

/*
 재생목록 50곡에서:


 힌트: 중복 제거는 Set으로 변환 후 다시 Array로 변환
 */
class PlayerManagerViewModel: ObservableObject {
    
    let songs: [Song] = [
        // K-pop (1-10)
        Song(
            title: "Blueming",
            artist: "아이유",
            duration: 215,
            genre: "K-pop",
            playCount: 15234567
        ),
        Song(
            title: "Dynamite",
            artist: "BTS",
            duration: 230,
            genre: "K-pop",
            playCount: 45678901
        ),
        Song(
            title: "How You Like That",
            artist: "BLACKPINK",
            duration: 189,
            genre: "K-pop",
            playCount: 38901234
        ),
        Song(
            title: "Ditto",
            artist: "NewJeans",
            duration: 178,
            genre: "K-pop",
            playCount: 12345678
        ),
        Song(
            title: "HOT",
            artist: "세븐틴",
            duration: 203,
            genre: "K-pop",
            playCount: 8901234
        ),
        Song(
            title: "Spicy",
            artist: "에스파",
            duration: 194,
            genre: "K-pop",
            playCount: 9876543
        ),
        Song(
            title: "Queencard",
            artist: "(여자)아이들",
            duration: 187,
            genre: "K-pop",
            playCount: 7654321
        ),
        Song(
            title: "Candy",
            artist: "NCT DREAM",
            duration: 212,
            genre: "K-pop",
            playCount: 6543210
        ),
        Song(
            title: "Kitsch",
            artist: "IVE",
            duration: 195,
            genre: "K-pop",
            playCount: 11234567
        ),
        Song(
            title: "Eve, Psyche & The Bluebeard's wife",
            artist: "르세라핌",
            duration: 201,
            genre: "K-pop",
            playCount: 8765432
        ),
        
        // Ballad (11-15)
        Song(
            title: "Square",
            artist: "백예린",
            duration: 245,
            genre: "Ballad",
            playCount: 5432109
        ),
        Song(
            title: "모든 날, 모든 순간",
            artist: "폴킴",
            duration: 267,
            genre: "Ballad",
            playCount: 6789012
        ),
        Song(
            title: "사랑인가 봐",
            artist: "멜로망스",
            duration: 234,
            genre: "Ballad",
            playCount: 4567890
        ),
        Song(
            title: "열애중",
            artist: "벤",
            duration: 253,
            genre: "Ballad",
            playCount: 3456789
        ),
        Song(
            title: "처음",
            artist: "성시경",
            duration: 278,
            genre: "Ballad",
            playCount: 7890123
        ),
        
        // Pop (16-25)
        Song(
            title: "Anti-Hero",
            artist: "Taylor Swift",
            duration: 221,
            genre: "Pop",
            playCount: 23456789
        ),
        Song(
            title: "Shape of You",
            artist: "Ed Sheeran",
            duration: 263,
            genre: "Pop",
            playCount: 19876543
        ),
        Song(
            title: "7 Rings",
            artist: "Ariana Grande",
            duration: 194,
            genre: "Pop",
            playCount: 17654321
        ),
        Song(
            title: "That's What I Like",
            artist: "Bruno Mars",
            duration: 226,
            genre: "Pop",
            playCount: 15432109
        ),
        Song(
            title: "Levitating",
            artist: "Dua Lipa",
            duration: 203,
            genre: "Pop",
            playCount: 14321098
        ),
        Song(
            title: "Blinding Lights",
            artist: "The Weeknd",
            duration: 258,
            genre: "Pop",
            playCount: 21098765
        ),
        Song(
            title: "bad guy",
            artist: "Billie Eilish",
            duration: 214,
            genre: "Pop",
            playCount: 16789012
        ),
        Song(
            title: "Peaches",
            artist: "Justin Bieber",
            duration: 189,
            genre: "Pop",
            playCount: 13210987
        ),
        Song(
            title: "good 4 u",
            artist: "Olivia Rodrigo",
            duration: 198,
            genre: "Pop",
            playCount: 11987654
        ),
        Song(
            title: "Señorita",
            artist: "Shawn Mendes",
            duration: 207,
            genre: "Pop",
            playCount: 9654321
        ),
        
        // Hip-hop (26-30)
        Song(
            title: "Born Hater",
            artist: "에픽하이",
            duration: 256,
            genre: "Hip-hop",
            playCount: 5678901
        ),
        Song(
            title: "Any Song",
            artist: "지코",
            duration: 189,
            genre: "Hip-hop",
            playCount: 6789012
        ),
        Song(
            title: "Nerdy Love",
            artist: "pH-1",
            duration: 201,
            genre: "Hip-hop",
            playCount: 3456789
        ),
        Song(
            title: "God's Plan",
            artist: "Drake",
            duration: 267,
            genre: "Hip-hop",
            playCount: 12345678
        ),
        Song(
            title: "Circles",
            artist: "Post Malone",
            duration: 234,
            genre: "Hip-hop",
            playCount: 10987654
        ),
        
        // Rock (31-35)
        Song(
            title: "You Were Beautiful",
            artist: "DAY6",
            duration: 243,
            genre: "Rock",
            playCount: 4567890
        ),
        Song(
            title: "Red",
            artist: "The Rose",
            duration: 256,
            genre: "Rock",
            playCount: 3210987
        ),
        Song(
            title: "Fix You",
            artist: "Coldplay",
            duration: 302,
            genre: "Rock",
            playCount: 18901234
        ),
        Song(
            title: "Believer",
            artist: "Imagine Dragons",
            duration: 223,
            genre: "Rock",
            playCount: 14567890
        ),
        Song(
            title: "Counting Stars",
            artist: "OneRepublic",
            duration: 245,
            genre: "Rock",
            playCount: 11234567
        ),
        
        // EDM (36-40)
        Song(
            title: "Happier",
            artist: "Marshmello",
            duration: 198,
            genre: "EDM",
            playCount: 8901234
        ),
        Song(
            title: "Faded",
            artist: "Alan Walker",
            duration: 215,
            genre: "EDM",
            playCount: 9876543
        ),
        Song(
            title: "Animals",
            artist: "Martin Garrix",
            duration: 203,
            genre: "EDM",
            playCount: 7654321
        ),
        Song(
            title: "Wake Me Up",
            artist: "Avicii",
            duration: 247,
            genre: "EDM",
            playCount: 13456789
        ),
        Song(
            title: "Summer",
            artist: "Calvin Harris",
            duration: 234,
            genre: "EDM",
            playCount: 10123456
        ),
        
        // R&B (41-44)
        Song(
            title: "Can You Feel It",
            artist: "헤이즈",
            duration: 234,
            genre: "R&B",
            playCount: 4321098
        ),
        Song(
            title: "D (half moon)",
            artist: "딘",
            duration: 212,
            genre: "R&B",
            playCount: 3987654
        ),
        Song(
            title: "Kill Bill",
            artist: "SZA",
            duration: 256,
            genre: "R&B",
            playCount: 9012345
        ),
        Song(
            title: "Focus",
            artist: "H.E.R.",
            duration: 243,
            genre: "R&B",
            playCount: 6789012
        ),
        
        // Indie (45-47)
        Song(
            title: "애상",
            artist: "10cm",
            duration: 267,
            genre: "Indie",
            playCount: 2345678
        ),
        Song(
            title: "위잉위잉",
            artist: "혁오",
            duration: 289,
            genre: "Indie",
            playCount: 3456789
        ),
        Song(
            title: "주저하는 연인들을 위해",
            artist: "잔나비",
            duration: 278,
            genre: "Indie",
            playCount: 5678901
        ),
        
        // Jazz/Classical (48-49)
        Song(
            title: "Fly Me to the Moon",
            artist: "나윤선",
            duration: 312,
            genre: "Jazz",
            playCount: 1234567
        ),
        Song(
            title: "River Flows in You",
            artist: "Yiruma",
            duration: 345,
            genre: "Classical",
            playCount: 6543210
        ),
        
        // 익명 (50)
        Song(
            title: "Unknown Track",
            artist: nil,
            duration: 187,
            genre: "Indie",
            playCount: 456789
        )
    ]

    
    // 1. filter: 5분(300초) 이상인 곡만 추출
    var overFiveMinutes: [Song] { songs.filter { $0.duration >= 300 } }
    
    // 3. reduce: 전체 재생목록의 총 재생시간 계산
    var totalPlayTimeOfAllSongs: String {
        let totalRunningTime = songs.map { $0.duration }.reduce(0, +)
        return "\(totalRunningTime / 3600)시간 \((totalRunningTime % 3600) / 60)분 \(totalRunningTime % 60)초"
    }
    
    // 4. sorted: 재생횟수 많은 순으로 정렬
    var orderOfPlayCount: [Song] { songs.sorted(by: { $0.playCount > $1.playCount }) }
    
    // 5. 복합: Rock 장르 → 3분 이상 → 재생횟수 상위 10곡 → 아티스트명 추출(중복 제거)
    var greatArtists: [String] {
        let longRockMusic = songs.filter { $0.genre == "Rock" && $0.duration >= 3 * 60 }
        let favoriteSongOfLongRockMusic = longRockMusic
            .sorted(by: { $0.playCount > $1.playCount })
            .prefix(10)
        return Array(Set(favoriteSongOfLongRockMusic.compactMap { $0.artist }))
    }
}

struct PlayerManager: View {
    @StateObject private var vm: PlayerManagerViewModel = PlayerManagerViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    //content
                    ForEach(vm.overFiveMinutes) { song in
                        HStack(alignment: .bottom) {
                            if let musician = song.artist {
                                Text(musician)
                                    .frame(width: 120)
                            } else {
                                Text("미상")
                                    .frame(width: 120)
                            }
                            Text(song.title)
                                .frame(width: 150)
                            Text("\(song.duration)초")
                                .frame(width: 120)
                        }
                    }
                } header: {
                    Text("5분 이상인 곡")
                }
                
                Section {
                    // content
                    ForEach(vm.songs) { song in
                        HStack(alignment: .bottom) {
                            if let musician = song.artist {
                                Text(musician)
                                    .frame(width: 120)
                            } else {
                                Text("미상")
                                    .frame(width: 120)
                            }
                            Text(song.title)
                                .frame(width: 160)
                            Text(song.durationWithFormat)
                                .frame(width: 50)
                        }
                    }
                } header: {
                    Text("모든 곡의 재생시간을 '분:초'로 변환")
                } footer: {
                    Text("전체 목록의 총 재생시간: \(vm.totalPlayTimeOfAllSongs)")
                }
                
                Section {
                    // content
                    ForEach(vm.orderOfPlayCount) { song in
                        HStack(alignment: .bottom) {
                            if let musician = song.artist {
                                Text(musician)
                                    .frame(width: 80)
                            } else {
                                Text("미상")
                                    .frame(width: 80)
                            }
                            Text(song.title)
                                .frame(width: 100)
                            Text("\(song.playCount)회 재생")
                                .frame(width: 180)
                        }
                    }
                } header: {
                    Text("재생 횟수 순 정렬")
                }
                
                Section {
                    // content
                    ForEach(vm.greatArtists, id: \.self) { artist in
                        HStack(alignment: .bottom) {
                            Text(artist)
                                .frame(width: 80)
                        }
                    }
                } header: {
                    Text("3분이상 재생시간 곡으로 재생 횟수 상위 10곡에 들어간 아티스트 목록")
                }

            }
            .navigationTitle("노래 분석")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PlayerManager()
}
