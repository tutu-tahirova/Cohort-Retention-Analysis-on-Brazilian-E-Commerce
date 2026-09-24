# Olist E-commerce Cohort Retention Analysis

## 1. Metodologiya və Texniki Yanaşma 
Bu analiz Braziliya e-ticarət platforması olan **Olist** dataseti üzərində müştəri saxlanma (retention) və təkrar alış davranışlarını qiymətləndirmək üçün həyata keçirilmişdir.
*  Yalnız statusu "delivered" (çatdırılmış) olan sifarişlər filtrələnərək analizə daxil edilmişdir.
*  Məlumatların emalı və dövrlərin hesablanması üçün **SQL** (Cohort məntiqi, strftime və period_time hesablamaları), vizualizasiya üçün isə **Python (Pandas, Seaborn)** istifadə olunmuşdur.
*  Hər bir müştərinin ilk alış ayı cohort_month olaraq təyin edilmiş, sonrakı alış ayları ilə ilkin ay arasındakı fərq ay hesabı ilə period_time kimi hesablanmışdır.

---

## 2. The customer_unique_id Trap
* Əgər analiz zamanı səhvən hər yeni sifariş üçün dəyişən **customer_id** sütunu istifadə olunsaydı, sistem hər sifarişi fərqli bir şəxs kimi qeydə alacaq və təkrar alışlar sıfır görünəcəkdi.
* Bu xətanın qarşısını almaq üçün real fiziki şəxsləri düzgün izləmək məqsədi ilə məhz **customer_unique_id** istifadə edilmişdir. Lakin buna baxmayaraq, təkrar alış göstəricilərinin yenə də çox aşağı olması problemin texniki deyil, biznes xarakterli olduğunu göstərdi.

---

## 3. Əsas Nəticələr və İnsightlər (4 Key Insights)

1. **Period 0-dan Sonra Kəskin Müştəri İtkisi (Massive Churn):**
   * İlk alış ayında bütün kohortlar üzrə retention **100.0%** olduğu halda, növbəti aya (Period 1) keçid zamanı bu göstərici kəskin şəkildə **0.3% - 0.8%** aralığına düşür.
   * *Nəticə:* Bu, platformanın təkrar alış baxımından çox zəif strukturuna malik olduğunu və müştərilərin 99%-dən çoxunun bir dəfə alıb bir daha geri qayıtmadığını sübut edir.
   * Tövsiyyə: Müştəri birinci alışını edir və bir daha platformanı unudur. İlk sifarişin çatdırıldığı tarixdən etibarən müəyyən günlərdə avtomatik xatırlatma emailləri qurulmalıdır. Məsələn:"Məhsuldan razı qaldınızmı?Ehtiyacınız ola biləcək oxşar məhsullar".

2. **Birdəfəlik Alıcılardan Yüksək Asılılıq:**
   * Biznesin gəlirləri tamamilə yeni müştərilərin cəlb edilməsinə bağlıdır.
   * Tövsiyyə:Müştərinin yenidən gəlməsi üçün heç bir maddi stimulu yoxdur. İlk alışdan dərhal sonra "Növbəti sifarişə 20% endirim" kuponları verilə bilər.

3. **Məhsul Kateqoriyasının Təsiri:**
   * Olist platformasında satılan əsas məhsulların mebel və məişət texnikası kimi uzunmüddətli istifadə olunan mallardan ibarətdirsə, bu təkrar ehtiyacın təbii olaraq gec yaranmasına səbəb olur.
   * Tövsiyyə: Platforma çeşidini sadəcə uzunmüddətli məhsullarla məhdudlaşdlrmamalı, daha çox tələbatlı mallara(supermarket məhsulları, şəxsi qulluq vasitələri, kosmetika və s.) fokuslanmalıdır.

4. **Zəif Təkrar Alış:**
   * Analiz nəticəsində rəqəmsal olaraq təsdiq olundu ki, platforma təkrar istehlakı stimullaşdıran daxili strategiyaları zəifdir.
   * Tövsiyyə: Müştərinin xərclədiyi məbləğin bir hissəsi kəşbek olaraq ona geri qayıtmalıdır ki, bu da onu növbəti alışlara təşviq etsin.
   * Həmçinin müştərinin ikinci dəfə qayıtmamasının əsas səbəblərindən biri ilk təcrübənin (gecikən çatdırılma və ya zəif keyfiyyət) pis olması ola bilər.Buna görə də müştəri məmnuniyyəti yüksək olan satıcılara önəm verilməlidir ki, müştəridə Olist brendinə qarşı etibar yaransın.
---
