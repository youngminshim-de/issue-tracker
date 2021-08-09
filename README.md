
<p align="center">
<img width="400" alt="이슈트래커" src="https://user-images.githubusercontent.com/45817559/128732226-9c57e53a-5592-490d-84c0-a6e70dd7146e.png">
</p>

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

<details>
 <summary>로그인 화면(Social Login) 상세 보기</summary>
<div markdown="로그인 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128681767-abb7706c-6975-424f-b0a1-3688622c8eb6.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128678641-bca1b39f-9cd6-4597-a486-428bdd8e28a5.gif" width="300">|
|:---:|:---:|
|**Login 화면**|**Login 동작 화면**|

- 소셜 로그인 구현(GitHub, Google, Kakao, Naver)
- 하단 TabBar에 유저의 Profile Image 적용

</div>
</details>

### 이슈 리스트 화면

<details>
<summary>이슈 리스트 화면 상세 보기</summary>
<div markdown="이슈리스트 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128685346-0fd59263-f54c-40b0-a522-29ca31fcaf14.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128685910-dc9e4b1b-25e4-46d9-a5b3-ddac9bca7835.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128685382-e85cdd87-7794-4a22-91d7-3ea349db9e0b.png" width="270">|
|:---:|:---:|:---:|
|**이슈 리스트**|**이슈 동적 셀**|**이슈 스와이프**|

- 로그인시 최초 화면에는 전체 열린 이슈 출력
- 각 이슈 내용, 레이블 갯수 및 크기, 마일스톤 유무에 따라 동적 크기 할당
- 스와이프 기능을 통해 이슈 삭제 및 닫기 구현

</div>
</details>
 
### 이슈 검색

<details>
<summary>이슈 검색 화면 상세 보기</summary>
<div markdown="이슈검색 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128687848-8aaea72c-d9a8-41fc-90e2-f5ab83784788.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128686809-b9ae4132-26d5-47a7-aa9c-eae570e5dc66.gif" width="300">|
|:---:|:---:|
|**이슈 검색**|**이슈 검색 동작 화면**|

- 검색 기능을 통해 이슈 필터링

</div>
</details>
 
### 이슈 필터

<details>
<summary>이슈 필터 화면 상세 보기</summary>
<div markdown="이슈필터 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128688758-8d41156a-185f-4604-a84c-feaf6d6293c2.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128688857-fae54a4c-6f27-40c7-be22-113235995367.gif" width="300">|
|:---:|:---:|
|**이슈 필터**|**이슈 필터 동작 화면**|

- 상단의 필터 버튼을 통해 필터 화면 출력
- 이슈 필터 기능 (각 섹션별로 1개)
- `이슈 상태`, `사용자 관련 이슈`, `작성자`, `레이블`, `마일스톤` 섹션 존재

</div>
</details>
 
### 이슈 선택

<details>
<summary>이슈 선택 화면 상세 보기</summary>
<div markdown="이슈선택 화면">
 
|<img src="https://user-images.githubusercontent.com/45817559/128711112-b1b75efc-daea-4c59-9f08-597e7ca92074.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128711136-3cd532ea-d0f3-4ed4-93e5-8548d024dc21.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128711146-0e643c3b-1cc4-4b8b-8532-fb571d48c9ea.gif" width="300">|
|:---:|:---:|:---:|
|**이슈 개별 선택**|**이슈 전체 선택**|**이슈 선택 동작 화면**|

- 상단의 선택 버튼을 통해 선택 화면 출력
- 이슈 선택(개별 선택, 전체 선택)을 통해 닫기 기능 구현

</div>
</details>
 
### 이슈 등록

<details>
<summary>이슈 등록 화면 상세 보기</summary>
<div markdown="이슈등록 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128715374-8c02ab63-a32e-4eaa-830e-2dc7fe2e3849.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128712789-fe27bd7d-8a05-4fd6-8725-0ae17765e2b4.gif" width="300">|
|:---:|:---:|
|**이슈 등록**|**이슈 등록 동작 화면**|

- 새로운 이슈 등록(제목, 코멘트, 레이블, 마일스톤, 담당자)
- 제목 및 코멘트 입력시 저장 버튼 활성화
- 마크다운 문법 형식으로 미리보기 구현
- 화면을 길게 눌러 사진 등록 가능

</div>
</details>
 
### 이슈 상세

<details>
<summary>이슈 상세 화면 상세 보기</summary>
<div markdown="이슈상세 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128722331-4fe978af-4d8e-414a-8336-2850f54c1d77.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128720422-08978573-be36-449d-9150-fbdea19b0327.gif" width="300">|
|:---:|:---:|
|**이슈 상세**|**코멘트 등록 동작 화면**|

|<img src="https://user-images.githubusercontent.com/45817559/128724164-b0639317-e101-4a80-a653-4f8ecc4d05ac.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128724563-8db53554-352f-4d90-80e4-8b6554ff2f30.gif" width="300">|
|:---:|:---:|
|**이슈 편집**|**이슈 편집 동작 화면**|

|<img src="https://user-images.githubusercontent.com/45817559/128724789-4092dfa2-719e-4acd-8174-59af59af8c0b.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128725184-c6816eed-b7ad-401f-950c-5b07daa76ad1.gif" width="300">|
|:---:|:---:|
|**코멘트 이모지**|**이모지 등록 동작 화면**|

|<img src="https://user-images.githubusercontent.com/45817559/128725321-3bed1bc9-f9d9-4e73-84a5-adcc173030d9.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128725654-f7f24247-6edc-4b65-a774-ba8da37d3054.gif" width="300">|
|:---:|:---:|
|**코멘트 수정 및 삭제**|**코멘트 수정 및 삭제 동작 화면**|

</div>
</details>
 
### 레이블 추가 및 편집

<details>
<summary>레이블 추가 및 편집 화면 상세 보기</summary>
<div markdown="레이블 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128727268-b33f19fc-85f1-4e91-b85f-25a3a0948826.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128727302-b3ff45a7-0470-4618-927b-2c77d7c31be8.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128726729-d8943742-839d-4ff1-8d4d-e9e4eef06c86.gif" width="300">|
|:---:|:---:|:---:|
|**레이블 리스트**|**레이블 추가 및 편집 화면**|**레이블 편집 동작 화면**|

- 스와이프를 통해 해당 레이블 편집, 삭제
- 배경색 지정시 포맷을 준수하도록 구현

</div>
</details>
 
### 마일스톤 추가 및 편집

<details>
<summary>마일스톤 추가 및 편집 화면 상세 보기</summary>
<div markdown="마일스톤 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128728832-acc9f410-a7bd-4ffc-a760-036335bd0284.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128728861-7b9055c7-22a8-4651-97b5-f2e6d59042de.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128728233-34a1069b-8de3-4093-903a-56b8657d0d9b.gif" width="300">|
|:---:|:---:|:---:|
|**마일스톤 리스트**|**마일스톤 추가 및 편집 화면**|**마일스톤 편집 동작 화면**|

- 스와이프를 통해 해당 마일스톤 편집, 삭제
- 완료일 지정시 포맷을 준수하도록 구현

</div>
</details> 

### 마이 페이지

<details>
<summary>마이 페이지 화면 상세 보기</summary>
<div markdown="마이페이지 화면">

|<img src="https://user-images.githubusercontent.com/45817559/128729737-274ef1a9-3784-4232-ab03-c2e8560e3107.png" width="270">|<img src="https://user-images.githubusercontent.com/45817559/128729494-c3b7722b-aaee-405c-b0d5-33967eb96c42.gif" width="300">|
|:---:|:---:|
|**마이 페이지**|**로그아웃 동작 화면**|

- 현재 로그인한 OAuthResource 확인 가능
- 내가 작성한 이슈 갯수 확인 가능
- 로그아웃 구현

</div>
</details>


---

### FrontEnd

https://user-images.githubusercontent.com/72348034/122523952-8c9e1c80-d052-11eb-8b3f-d5b7bc5db09c.mp4

---
