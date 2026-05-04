//
//  ComplimentLocalDataSource.swift
//  ComplimentLab
//

import Foundation

struct ComplimentLocalDataSource {

    static let compliments: [Compliment] = [
        Compliment(id: 1,  content: "오늘도 한 발자국 나아갔네요.\n그 걸음이 모여 더 큰 변화를 만들 거예요!", type: .kind),
        Compliment(id: 2,  content: "조금씩 꾸준히 해내는 모습이 참 멋져요.\n이 꾸준함이 결국 큰 힘이 될 거예요!", type: .kind),
        Compliment(id: 3,  content: "실패해도 다시 일어나는 마음이 멋져요.\n그 경험들이 더 단단하게 만들어 줄 거예요!", type: .kind),
        Compliment(id: 4,  content: "끝까지 포기하지 않은 태도가 대단해요.\n이 인내가 꼭 결실로 이어질 거예요!", type: .kind),
        Compliment(id: 5,  content: "오늘도 정성스럽게 임했군요.\n이런 하루들이 모여 큰 성장을 이끌 거예요!", type: .kind),
        Compliment(id: 6,  content: "차근차근 준비하는 모습이 인상 깊었어요.\n그 과정이 곧 자신감을 만들어줄 거예요!", type: .kind),
        Compliment(id: 7,  content: "조용히 집중하는 모습이 참 멋져요.\n이 힘이 분명히 좋은 결과로 이어질 거예요!", type: .kind),
        Compliment(id: 8,  content: "늘 성실하게 임하는 태도가 좋아요.\n이 꾸준함이 큰 변화를 가져올 거예요!", type: .kind),
        Compliment(id: 9,  content: "조금씩 달라지는 게 보여요.\n이 변화가 쌓이면 더 멋진 내일이 올 거예요!", type: .kind),
        Compliment(id: 10, content: "한 단계씩 밟아가는 모습이 믿음직스러워요.\n그 발걸음이 멀리 나아갈 거예요!", type: .kind),
        Compliment(id: 11, content: "실수도 배움으로 삼는 게 멋져요.\n이 경험이 모여 반드시 성장의 밑거름이 될 거예요!", type: .kind),
        Compliment(id: 12, content: "노력하는 과정 자체가 빛나요.\n그 빛이 점점 더 크게 번져나갈 거예요!", type: .kind),
        Compliment(id: 13, content: "끝까지 책임지려는 모습이 대단해요.\n그 마음이 결국 성취를 만들 거예요!", type: .kind),
        Compliment(id: 14, content: "오늘도 차분히 해내고 있군요.\n이 차분함이 더 큰 자신감으로 바뀔 거예요!", type: .kind),
        Compliment(id: 15, content: "계속 도전하는 모습이 용기 있어 보여요.\n그 용기가 더 단단하게 만들 거예요!", type: .kind),
        Compliment(id: 16, content: "작은 시도조차도 의미 있어요.\n이 시도가 결국 큰 변화를 가져올 거예요!", type: .kind),
        Compliment(id: 17, content: "늘 배우려는 태도가 존경스러워요.\n그 배움이 앞으로의 길을 넓혀줄 거예요!", type: .kind),
        Compliment(id: 18, content: "조금 늦더라도 꾸준히 하는 게 멋져요.\n그 꾸준함이 꼭 빛날 거라고 믿어요!", type: .kind),
        Compliment(id: 19, content: "작은 성취도 소중히 여기는 게 좋아요.\n그 마음이 더 큰 성취로 이어질 거예요!", type: .kind),
        Compliment(id: 20, content: "지치지 않고 나아가는 모습이 대단해요.\n이 끈기가 놀라운 결실을 맺을 거예요!", type: .kind),
        Compliment(id: 21, content: "차근차근 쌓아가는 모습이 믿음직스러워요.\n이런 시간들까지 함께 쌓여 결국 큰 힘이 될 거예요!", type: .kind),
        Compliment(id: 22, content: "어제보다 나은 오늘을 만들었네요.\n분명 내일은 더 좋은 내일을 열 거예요!", type: .kind),
        Compliment(id: 23, content: "꾸준히 이어가는 게 참 대단해요.\n이 길이 멀리까지 이어지길 응원해요!", type: .kind),
        Compliment(id: 24, content: "실패에도 굴하지 않는 게 멋져요.\n그 용기가 더 큰 성장을 부를 거예요!", type: .kind),
        Compliment(id: 25, content: "오늘도 최선을 다했군요.\n그 최선이 반드시 보답받을 거예요!", type: .kind),
        Compliment(id: 26, content: "방금 집중하는 모습이 눈에 띄었어요.\n바로 모두가 몰입하게 됐어요!", type: .energetic),
        Compliment(id: 27, content: "지금 보여주신 태도가 참 당당했어요.\n덕분에 분위기가 한층 밝아졌어요!", type: .energetic),
        Compliment(id: 28, content: "와, 금세 몰입하신 게 대단해요.\n바로 성과로 나타났어요!", type: .energetic),
        Compliment(id: 29, content: "짧은 순간에도 열정을 다하시더군요.\n에너지가 곧장 전해졌어요!", type: .energetic),
        Compliment(id: 30, content: "적극적으로 임하신 게 인상적이었어요.\n순간 모두가 힘을 얻었어요!", type: .energetic),
        Compliment(id: 31, content: "즉시 행동으로 옮기신 게 멋졌어요.\n결단이 현장을 바꿔놓았어요!", type: .energetic),
        Compliment(id: 32, content: "순간 내신 아이디어가 반짝였어요.\n아이디어가 사람들의 시선을 끌었어요!", type: .energetic),
        Compliment(id: 33, content: "오늘 보여주신 집중력은 놀라웠어요.\n집중하는 모습이 멋졌어요!", type: .energetic),
        Compliment(id: 34, content: "지금 태도가 진지해서 좋았어요.\n진심이 그대로 전해졌어요!", type: .energetic),
        Compliment(id: 35, content: "빠르고 정확한 반응이 돋보였어요.\n판단이 상황을 안정시켰어요!", type: .energetic),
        Compliment(id: 36, content: "바로 움직이신 게 참 대단했어요.\n용기가 모두에게 힘이 됐어요!", type: .energetic),
        Compliment(id: 37, content: "열정적인 자세가 너무 인상적이었어요.\n덕분에 분위기가 환해졌어요!", type: .energetic),
        Compliment(id: 38, content: "오늘 내뿜으신 에너지가 느껴졌어요.\n활력이 모두에게 번졌어요!", type: .energetic),
        Compliment(id: 39, content: "빠른 판단을 해낸 하루였어요.\n순발력이 기회를 열었어요!", type: .energetic),
        Compliment(id: 40, content: "방금의 눈빛이 강렬했어요.\n눈빛이 가능성을 보여줬어요!", type: .energetic),
        Compliment(id: 41, content: "재빨리 행동하신 게 멋졌어요.\n선택이 분위기를 달라지게 했어요!", type: .energetic),
        Compliment(id: 42, content: "순간 최선을 다하신 게 감동이었어요.\n진심이 금세 전해졌어요!", type: .energetic),
        Compliment(id: 43, content: "오늘 참여가 활발했어요.\n열정이 공간을 따뜻하게 했어요!", type: .energetic),
        Compliment(id: 44, content: "곧장 임하신 태도가 돋보였어요.\n적극성이 힘을 불어넣었어요!", type: .energetic),
        Compliment(id: 45, content: "즉시 보여주신 반응이 멋졌어요.\n반응이 곧바로 효과를 냈어요!", type: .energetic),
        Compliment(id: 46, content: "끝까지 포기하지 않는 모습이 감동이에요!\n그 끈기가 모든 걸 가능하게 만들어요.", type: .energetic),
        Compliment(id: 47, content: "주변을 배려하며 행동이 따뜻했어요!\n그런 마음이 모두에게 좋은 에너지가 돼요.", type: .energetic),
        Compliment(id: 48, content: "오늘의 노력이 고스란히 보여요!\n그 꾸준함이 내일의 힘이 될 거예요.", type: .energetic),
        Compliment(id: 49, content: "새로운 걸 시도하는 용기가 멋져요!\n그 도전이 당신의 가능성을 넓혀줄 거예요.", type: .energetic),
        Compliment(id: 50, content: "작더라도 꾸준히 이어가는 모습이 인상적이에요!\n그런 모습을 응원할게요.", type: .energetic),
        Compliment(id: 51, content: "오늘의 성과가 분명히 드러났어요!\n성과가 곧 다음 변화를 이끌 거예요.", type: .quiet),
        Compliment(id: 52, content: "마무리가 깔끔했네요.\n정돈된 마침표가 큰 신뢰를 만들었어요!", type: .quiet),
        Compliment(id: 53, content: "기대 이상의 결과였어요!\n성과 자체가 든든한 힘이 되었을 거예요.", type: .quiet),
        Compliment(id: 54, content: "오늘의 성과가 모두에게 힘이 되었어요!\n성과가 오래 기억될 거예요.", type: .quiet),
        Compliment(id: 55, content: "완성도가 높아 눈길을 끌었어요.\n높은 완성도가 기준을 세웠네요!", type: .quiet),
        Compliment(id: 56, content: "목표를 정확히 달성했네요!\n달성의 순간이 새로운 도약으로 이어질 거예요.", type: .quiet),
        Compliment(id: 57, content: "오늘의 결과는 탁월했어요!\n성과의 울림이 주위로 퍼져 나갔어요.", type: .quiet),
        Compliment(id: 58, content: "결과물이 선명했네요.\n선명한 성과는 강점이 되어 돌아올 거예요!", type: .quiet),
        Compliment(id: 59, content: "성과가 분명히 나타났어요!\n이 성과는 더 큰 무대를 준비하게 만들 거예요.", type: .quiet),
        Compliment(id: 60, content: "이번 성과는 모두가 인정할 만큼 뛰어났어요!\n인정받은 성취가 자신감을 남겼어요.", type: .quiet),
        Compliment(id: 61, content: "마무리에서 세심함이 드러났어요.\n섬세한 마침이 또 다른 결과를 부르네요!", type: .quiet),
        Compliment(id: 62, content: "오늘의 성취가 인상적이었어요!\n높은 성취가 스스로의 기준을 끌어올렸어요.", type: .quiet),
        Compliment(id: 63, content: "완벽에 가까운 결과였어요.\n탄탄한 결과는 오래 버팀목이 될 거예요!", type: .quiet),
        Compliment(id: 64, content: "눈에 보이는 성과가 확실했네요!\n확실한 성취가 큰 발걸음을 낳을 거예요.", type: .quiet),
        Compliment(id: 65, content: "결실이 단단히 맺혔어요!\n단단한 성과는 다음 도전을 지탱할 거예요.", type: .quiet),
        Compliment(id: 66, content: "오늘의 결과는 누구나 주목할 만했어요!\n주목받은 순간이 새로운 기회가 되겠네요.", type: .quiet),
        Compliment(id: 67, content: "성취가 또렷하게 남았네요.\n남은 성과는 성장의 증거가 될 거예요!", type: .quiet),
        Compliment(id: 68, content: "결과물의 질이 높았어요!\n높은 완성도가 기준을 끌어올렸어요.", type: .quiet),
        Compliment(id: 69, content: "오늘의 성과는 자랑스러웠어요!\n자랑스러운 결실이 원동력이 되겠네요.", type: .quiet),
        Compliment(id: 70, content: "완성도가 돋보였네요!\n돋보인 결과가 당신만의 색깔을 만들었어요.", type: .quiet),
        Compliment(id: 71, content: "오늘의 결과가 변화를 만들었어요!\n변화의 성과가 울림으로 전해졌어요.", type: .quiet),
        Compliment(id: 72, content: "성취가 눈부셨네요!\n눈부신 결과가 다음 길을 밝혀줄 거예요.", type: .quiet),
        Compliment(id: 73, content: "오늘의 성과는 의미가 있었어요!\n의미 있는 결실이 연결을 확장시켰어요.", type: .quiet),
        Compliment(id: 74, content: "결과물이 기대 이상이었네요!\n만족스러운 성취가 또 다른 도전을 열어주었어요.", type: .quiet),
        Compliment(id: 75, content: "성취가 선명히 남았어요!\n선명한 발자취가 새로운 시작이 될 거예요.", type: .quiet),
        Compliment(id: 76,  content: "당신의 따뜻한 성격이 드러났어요!\n덕분에 주변도 함께 편안해졌어요.", type: .special),
        Compliment(id: 77,  content: "차분한 태도가 인상적이었어요.\n앞으로 더 많은 이들에게 신뢰를 줄 거예요!", type: .special),
        Compliment(id: 78,  content: "독창적인 감각이 돋보였네요!\n앞으로 더 새로운 시도를 이끌 수 있겠어요.", type: .special),
        Compliment(id: 79,  content: "섬세한 성격 덕분에 작은 부분까지 빛났어요.\n그 세심함이 큰 힘이 될 거예요!", type: .special),
        Compliment(id: 80,  content: "밝은 에너지가 전해졌어요!\n주변도 덩달아 활기를 얻었어요.", type: .special),
        Compliment(id: 81,  content: "유연한 태도가 참 멋졌어요.\n앞으로 더 많은 상황에서 강점이 될 거예요!", type: .special),
        Compliment(id: 82,  content: "책임감 있는 모습이 드러났네요!\n모두가 더 든든함을 느낄 거예요.", type: .special),
        Compliment(id: 83,  content: "긍정적인 기운이 인상적이었어요.\n앞으로 더 많은 변화를 불러올 거예요!", type: .special),
        Compliment(id: 84,  content: "배려심이 묻어났어요!\n그 마음이 오래 기억될 거예요.", type: .special),
        Compliment(id: 85,  content: "당당한 태도가 참 인상 깊었네요.\n앞으로 더 큰 자신감으로 이어질 거예요!", type: .special),
        Compliment(id: 86,  content: "창의적인 시선이 빛났어요!\n새로운 길을 여는 힘이 될 거예요.", type: .special),
        Compliment(id: 87,  content: "진중한 태도가 돋보였네요.\n앞으로 더 깊은 신뢰를 얻을 거예요!", type: .special),
        Compliment(id: 88,  content: "솔직함이 빛났어요!\n덕분에 분위기가 더 투명해졌어요.", type: .special),
        Compliment(id: 89,  content: "따뜻한 마음이 느껴졌어요.\n앞으로 더 많은 이들에게 힘이 될 거예요!", type: .special),
        Compliment(id: 90,  content: "열정적인 기운이 전해졌네요!\n다음에도 큰 원동력이 될 거예요.", type: .special),
        Compliment(id: 91,  content: "친근한 매력이 인상적이었어요.\n앞으로 더 많은 연결을 만들 거예요!", type: .special),
        Compliment(id: 92,  content: "성실함이 그대로 드러났네요.\n앞으로도 꾸준한 신뢰를 쌓을 수 있겠어요!", type: .special),
        Compliment(id: 93,  content: "침착한 태도가 빛났어요!\n덕분에 모두가 안정감을 느꼈어요.", type: .special),
        Compliment(id: 94,  content: "꾸준한 자세가 참 멋졌네요.\n앞으로 더 큰 성취로 이어질 거예요!", type: .special),
        Compliment(id: 95,  content: "배움에 열린 태도가 돋보였어요!\n앞으로 더 많은 성장을 이끌 거예요.", type: .special),
        Compliment(id: 96,  content: "활발한 성격이 분위기를 살렸어요.\n다음에도 모두가 힘을 얻을 거예요!", type: .special),
        Compliment(id: 97,  content: "진심 어린 태도가 인상적이었어요!\n앞으로 더 큰 울림으로 전해질 거예요.", type: .special),
        Compliment(id: 98,  content: "도전적인 면모가 눈에 띄었어요.\n앞으로 더 많은 성과로 이어질 거예요!", type: .special),
        Compliment(id: 99,  content: "겸손한 태도가 참 멋졌네요!\n덕분에 모두가 편안해졌어요.", type: .special),
        Compliment(id: 100, content: "유머러스한 매력이 드러났어요.\n앞으로 더 많은 웃음을 나눌 수 있을 거예요!", type: .special),
        Compliment(id: 101, content: "이번 선택은 근거가 분명했어요!\n앞으로 더 설득력 있게 다가올 거예요.", type: .studious),
        Compliment(id: 102, content: "오늘의 정리는 체계적이었네요.\n다음에도 빠르게 응용할 수 있겠어요!", type: .studious),
        Compliment(id: 103, content: "문제를 풀어가는 방식이 논리적이었어요!\n다음에 더 복잡한 상황도 헤쳐 나갈 수 있겠어요.", type: .studious),
        Compliment(id: 104, content: "설명이 명확해서 이해가 쉬웠어요.\n앞으로 더 많은 사람을 설득할 수 있겠어요!", type: .studious),
        Compliment(id: 105, content: "자료를 활용하는 게 인상적이었네요!\n곧 더 깊이 있는 결과로 이어질 거예요.", type: .studious),
        Compliment(id: 106, content: "분석 과정이 구체적이었어요.\n앞으로 더 넓은 시야로 발전할 거예요!", type: .studious),
        Compliment(id: 107, content: "근거를 들어 이야기한 게 좋았어요!\n앞으로 더 신뢰를 얻을 수 있을 거예요.", type: .studious),
        Compliment(id: 108, content: "단계별 접근이 정확했네요.\n앞으로 어떤 문제에도 체계적으로 맞설 수 있겠어요!", type: .studious),
        Compliment(id: 109, content: "비교하는 방식이 합리적이었어요!\n곧 더 현명한 판단으로 이어질 거예요.", type: .studious),
        Compliment(id: 110, content: "디테일을 놓치지 않은 점이 돋보였어요.\n앞으로 더 큰 그림까지 그릴 수 있겠어요!", type: .studious),
        Compliment(id: 111, content: "설명 속에 근거가 충분했어요!\n곧 더 큰 자신감으로 이어질 거예요.", type: .studious),
        Compliment(id: 112, content: "구체적인 수치를 들어서 신뢰가 갔어요.\n앞으로 더 영향력 있는 이야기를 할 수 있겠어요!", type: .studious),
        Compliment(id: 113, content: "흐름을 짚어주는 게 탁월했네요!\n다음엔 더 복잡한 내용도 잘 이끌 수 있을 거예요.", type: .studious),
        Compliment(id: 114, content: "사실에 기반한 판단이 좋았어요.\n앞으로 더 큰 신뢰를 얻게 될 거예요!", type: .studious),
        Compliment(id: 115, content: "세부 내용을 챙기는 게 섬세했어요!\n곧 더 정교한 결과로 이어질 거예요.", type: .studious),
        Compliment(id: 116, content: "과정을 기록해둔 게 돋보였네요.\n앞으로 더 체계적인 습관이 될 거예요!", type: .studious),
        Compliment(id: 117, content: "핵심을 뽑아내는 게 탁월했어요!\n앞으로 더 빠른 해결로 이어질 거예요.", type: .studious),
        Compliment(id: 118, content: "사례를 근거로 제시한 게 설득력 있었어요.\n앞으로 더 많은 공감을 얻을 수 있겠어요!", type: .studious),
        Compliment(id: 119, content: "논리의 흐름이 분명했어요!\n앞으로 더 복잡한 생각도 잘 정리할 수 있을 거예요.", type: .studious),
        Compliment(id: 120, content: "오늘의 선택 기준이 뚜렷했네요.\n앞으로 더 큰 결정을 내리는 데 힘이 될 거예요!", type: .studious),
        Compliment(id: 121, content: "질문에 답할 때 근거가 분명했어요!\n앞으로 더 자신 있게 말할 수 있겠어요.", type: .studious),
        Compliment(id: 122, content: "단서를 모으는 과정이 뛰어났어요.\n곧 더 큰 그림을 완성할 수 있을 거예요!", type: .studious),
        Compliment(id: 123, content: "차이를 구체적으로 짚은 게 좋았어요!\n앞으로 더 정밀한 분석으로 이어질 거예요.", type: .studious),
        Compliment(id: 124, content: "정답보다 과정에 집중한 게 인상 깊었어요.\n앞으로 더 깊은 학습으로 이어질 거예요!", type: .studious),
        Compliment(id: 125, content: "오늘의 설명은 구체적이었네요!\n앞으로 더 오래 기억될 거예요.", type: .studious),
    ]

    /// 특정 날짜의 칭찬 반환 (상태값 없음 - ViewModel에서 recordStore와 조합)
    static func compliment(for date: Date, userUID: String) -> Compliment {
        return compliments[complimentIndex(for: date, userUID: userUID)]
    }

    static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // MARK: - Private

    /// userUID를 seed로 삼아 날짜별 칭찬 인덱스를 결정
    /// - 같은 사용자 + 같은 날 → 항상 같은 칭찬
    /// - 사용자마다 다른 offset → 같은 날이라도 다른 칭찬
    private static func complimentIndex(for date: Date, userUID: String) -> Int {
        let calendar = Calendar.current
        let epoch = calendar.startOfDay(for: Date(timeIntervalSince1970: 0))
        let days = calendar.dateComponents([.day], from: epoch, to: calendar.startOfDay(for: date)).day ?? 0
        let userSum = userUID.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        let seed = (days &* 1664525) ^ (userSum &* 1013904223)
        return abs(seed) % compliments.count
    }
}
