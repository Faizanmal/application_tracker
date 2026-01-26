from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    CompanyProfileViewSet,
    SalaryDataViewSet,
    IndustryTrendViewSet,
    HiringSeasonDataViewSet,
    JobMarketHeatmapViewSet,
    SuccessPredictionViewSet,
    JobSearchROIViewSet,
)

router = DefaultRouter()
router.register(r'companies', CompanyProfileViewSet, basename='companies')
router.register(r'salaries', SalaryDataViewSet, basename='salaries')
router.register(r'industry-trends', IndustryTrendViewSet, basename='industry-trends')
router.register(r'hiring-seasons', HiringSeasonDataViewSet, basename='hiring-seasons')
router.register(r'heatmap', JobMarketHeatmapViewSet, basename='heatmap')
router.register(r'predictions', SuccessPredictionViewSet, basename='predictions')
router.register(r'roi', JobSearchROIViewSet, basename='roi')

urlpatterns = [
    path('', include(router.urls)),
]
