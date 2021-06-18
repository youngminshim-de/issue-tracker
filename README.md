
# issue-tracker

## 팀 소개 (TEAM 2)

|`BE`|`iOS`|`FE`|
|---|---|---|
|🐯Shion|🐵Aiden|🐱Sienna
|🐰Yeon|🐷BMO|

## 팀 규칙

- 정해진 회의 일정은 없음(필요할 경우 팀원들에게 요청하여 진행)
- 회의가 없는 대신 매일 5시 40분 회고 진행(각자 하루 일과 및 개발 진행 상황 전달)
- 회고 진행과 동시에 개발일지 작성

## 2주차 데모 
### iOS 데모 영상

### 로그인 화면 (GitHub Login)

<p align="center">
<img width="250" alt="1" src="https://user-images.githubusercontent.com/45817559/122515334-4217a280-d048-11eb-973b-5bbf8ad595ca.gif">
</p>

- GitHub 로그인 구현
- 로그인 성공시 다음 페이지로 이동
- 하단 TabBar에 유저의 GitHub Profile Image 적용


### 이슈 리스트 화면

<p align="center">
<img width="250" alt="2" src="https://user-images.githubusercontent.com/45817559/122516200-6fb11b80-d049-11eb-85f0-ab2acfd63502.gif">
</p>

- 테이블뷰를 아래로 당기면 SearchBar 두둥등장 (동시에 테이블뷰 하단에 있는 안내 문구가 사라짐)
- 왼쪽 상단의 필터 버튼을 누르면 이슈를 필터별로 나열 (네트워크 미구현)
- 오른쪽 상단의 선택 버튼을 누르면 이슈 선택창으로 이동 (네트워크, 선택 미구현)


### 이슈 추가 & 레이블 화면

<p align="center">
<img width="250" alt="3" src="https://user-images.githubusercontent.com/45817559/122516858-40e77500-d04a-11eb-985d-63b79e5a0aac.gif">
</p>

- 오른쪽 하단의 `+`버튼 클릭 시 이슈 추가 화면으로 이동
- 제목과 내용 작성 가능
- 레이블, 마일스톤, 담당자 선택 가능 (미구현)
- 레이블 화면에서는 작성된 모든 레이블 출력 (네트워크 미구현)

---

### FrontEnd

https://user-images.githubusercontent.com/72348034/122523952-8c9e1c80-d052-11eb-8b3f-d5b7bc5db09c.mp4

---

### BackEnd

- **DB Schema**

![issue-tracker](https://user-images.githubusercontent.com/46085281/122386485-e5b17600-cfa8-11eb-8469-0f46b21ffd0a.png)

- [백엔드 스토리](https://github.com/Sonjh1306/issue-tracker/wiki/%5BBE%5D-%EC%8A%A4%ED%86%A0%EB%A6%AC)
- [백엔드 기술스택](https://github.com/Sonjh1306/issue-tracker/wiki/%EB%B0%B1%EC%97%94%EB%93%9C-%EA%B8%B0%EC%88%A0%EC%8A%A4%ED%83%9D)
- [Mockup API](https://documenter.getpostman.com/view/15041629/TzeWHTpw)


