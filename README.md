# issue-tracker 

- GitHub 이슈 관리 서비스를 구현한 프로젝트 
- 👉[Issue tracker Service Flow](https://github.com/Sonjh1306/issue-tracker/wiki/%5BBE%5D-Issue-tracker-Service-Flow)
- 👉배포 주소 : http://www.sionn.net

## 팀 소개 (TEAM 2)

|`BE`|`iOS`|`FE`|
|---|---|---|
|🐯Shion|🐵Aiden|🐱Sienna
|🐰Yeon|🐷BMO|

### - [Ground Rule](https://github.com/Sonjh1306/issue-tracker/wiki)



## BackEnd
- 👉[백엔드 기술스택](https://github.com/Sonjh1306/issue-tracker/wiki/%EB%B0%B1%EC%97%94%EB%93%9C-%EA%B8%B0%EC%88%A0%EC%8A%A4%ED%83%9D)
- **DB Schema**

<p align="center">
<img width="800" alt="BE1" src="https://user-images.githubusercontent.com/46085281/122386485-e5b17600-cfa8-11eb-8469-0f46b21ffd0a.png">
</p>

- **Server Structure**
 
<p align="center">
<img width="800" alt="BE2" src="https://i.imgur.com/801OpXj.png">
</p>
 
- 👉[Postman Mockup API](https://documenter.getpostman.com/view/15041629/TzeWHTpw)
- 👉[Swagger API Documents](http://www.sionn.net/swagger-ui.html#/)


## iOS 

### 로그인 화면 (Social Login)

|<img src="https://user-images.githubusercontent.com/45817559/128681767-abb7706c-6975-424f-b0a1-3688622c8eb6.png" width="300">|<img src="https://user-images.githubusercontent.com/45817559/128678641-bca1b39f-9cd6-4597-a486-428bdd8e28a5.gif" width="300">|
|:---:|:---:|
|Login 화면|Login 동작 화면|


- 소셜 로그인 구현(GitHub, Google, Kakao, Naver)
- 하단 TabBar에 유저의 Profile Image 적용


### 이슈 리스트 화면

|<img src="https://user-images.githubusercontent.com/45817559/128685346-0fd59263-f54c-40b0-a522-29ca31fcaf14.png" width="300">|<img src="https://user-images.githubusercontent.com/45817559/128685910-dc9e4b1b-25e4-46d9-a5b3-ddac9bca7835.png" width="300">|<img src="https://user-images.githubusercontent.com/45817559/128685382-e85cdd87-7794-4a22-91d7-3ea349db9e0b.png" width="300">|
|:---:|:---:|:---:|
|이슈 리스트|이슈 동적 셀|이슈 스와이프|

- 로그인시 최초 화면에는 전체 열린 이슈 출력
- 각 이슈 내용, 레이블 갯수 및 크기, 마일스톤 유무에 따라 동적 크기 할당
- 스와이프 기능을 통해 이슈 삭제 및 닫기 구현

### 이슈 검색

|<img src="https://user-images.githubusercontent.com/45817559/128687848-8aaea72c-d9a8-41fc-90e2-f5ab83784788.png" width="300">|<img src="https://user-images.githubusercontent.com/45817559/128686809-b9ae4132-26d5-47a7-aa9c-eae570e5dc66.gif" width="300">|
|:---:|:---:|
|이슈 검색|이슈 검색 동작 화면|

- 검색 기능을 통해 이슈 필터링

### 이슈 필터

|<img src="https://user-images.githubusercontent.com/45817559/128688758-8d41156a-185f-4604-a84c-feaf6d6293c2.png" width="300">|<img src="https://user-images.githubusercontent.com/45817559/128688857-fae54a4c-6f27-40c7-be22-113235995367.gif" width="300">|
|:---:|:---:|
|이슈 필터|이슈 필터 동작 화면|

- 상단의 필터 버튼을 통해 필터 화면 출력
- 이슈 필터 기능 (각 섹션별로 1개)
- `이슈 상태`, `사용자 관련 이슈`, `작성자`, `레이블`, `마일스톤` 섹션 존재

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
