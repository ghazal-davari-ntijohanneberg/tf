var slideIndex = 1;
showDivs(slideIndex);

document.getElementById("left-hover").addEventListener("click", function() {
  plusDivs(-1);
});

document.getElementById("right-hover").addEventListener("click", function() {
  plusDivs(1);
});

document.getElementById("slide_1").addEventListener("click", function(){
  currentDiv(1);
})

document.getElementById("slide_2").addEventListener("click", function(){
  currentDiv(2);
})

document.getElementById("slide_3").addEventListener("click", function(){
  currentDiv(3);
})

document.getElementById("slide_4").addEventListener("click", function(){
  currentDiv(4);
})


function plusDivs(n) {
  showDivs(slideIndex += n);
}

function currentDiv(n) {
  showDivs(slideIndex = n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("mySlides");
  var dots = document.getElementsByClassName("demo");
  
  if (n > x.length) {
    slideIndex = 1;
  }
  
  if (n < 1) {
    slideIndex = x.length;
  }
  
  for (i = 0; i < x.length; i += 1) {
    x[i].style.display = "none";
  }
  
  for (i = 0; i < dots.length; i += 1) {
    dots[i].className = dots[i].className.replace(" w3-white", "");
  }
  
  x[slideIndex - 1].style.display = "block";
  dots[slideIndex - 1].className += " w3-white";
}